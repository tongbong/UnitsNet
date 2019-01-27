﻿using module ".\Types.psm1"

function GenerateStaticQuantitySourceCode([Quantity[]]$quantities)
{
@"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by \generate-code.bat.
//
//     Changes to this file will be lost when the code is regenerated.
//     The build server regenerates the code before each build and a pre-build
//     step will regenerate the code on each local build.
//
//     See https://github.com/angularsen/UnitsNet/wiki/Adding-a-New-Unit for how to add or edit units.
//
//     Add CustomCode\Quantities\MyQuantity.extra.cs files to add code to generated quantities.
//     Add UnitDefinitions\MyQuantity.json and run generate-code.bat to generate new units or quantities.
//
// </auto-generated>
//------------------------------------------------------------------------------

// Copyright (c) 2013 Andreas Gullberg Larsen (andreas.larsen84@gmail.com).
// https://github.com/angularsen/UnitsNet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

using System;
using System.Linq;
using UnitsNet.Units;

namespace UnitsNet
{
    /// <summary>
    ///     Dynamically parse or construct quantities when types are only known at runtime.
    /// </summary>
    public static partial class Quantity
    {
        /// <summary>
        ///     Dynamically construct a quantity.
        /// </summary>
        /// <param name="value">Numeric value.</param>
        /// <param name="unit">Unit enum value.</param>
        /// <returns>An <see cref="IQuantity"/> object.</returns>
        /// <exception cref="ArgumentException">Unit value is not a know unit enum type.</exception>
        public static IQuantity From(QuantityValue value, Enum unit)
        {
            if (TryFrom(value, unit, out IQuantity quantity))
                return quantity;

            throw new ArgumentException(
                $"Unit value {unit} of type {unit.GetType()} is not a known unit enum type. Expected types like UnitsNet.Units.LengthUnit. Did you pass in a third-party enum type defined outside UnitsNet library?");
        }

        /// <summary>
        ///     Try to dynamically construct a quantity.
        /// </summary>
        /// <param name="value">Numeric value.</param>
        /// <param name="unit">Unit enum value.</param>
        /// <returns><c>True</c> if successful with <paramref name="quantity"/> assigned the value, otherwise <c>false</c>.</returns>
        public static bool TryFrom(QuantityValue value, Enum unit, out IQuantity quantity)
        {
            switch (unit)
            {
"@; foreach ($quantity in $quantities) {
        $quantityName = $quantity.Name
        $unitTypeName = $quantityName + "Unit"
        $unitValue = toCamelCase($unitTypeName);@"
                case $unitTypeName $($unitValue):
                    quantity = $quantityName.From(value, $unitValue);
                    return true;
"@; }@"
                default:
                {
                    quantity = default(IQuantity);
                    return false;
                }
            }
        }

        /// <summary>
        ///     Dynamically parse a quantity string representation.
        /// </summary>
        /// <param name="quantityType">Type of quantity, such as <see cref="Length"/>.</param>
        /// <param name="quantityString">Quantity string representation, such as "1.5 kg". Must be compatible with given quantity type.</param>
        /// <returns>The parsed quantity.</returns>
        /// <exception cref="ArgumentException">Type must be of type UnitsNet.IQuantity -or- Type is not a known quantity type.</exception>
        public static IQuantity Parse(Type quantityType, string quantityString)
        {
            if (!typeof(IQuantity).IsAssignableFrom(quantityType))
                throw new ArgumentException($"Type {quantityType} must be of type UnitsNet.IQuantity.");

            if (TryParse(quantityType, quantityString, out IQuantity quantity)) return quantity;

            throw new ArgumentException($"Quantity string could not be parsed to quantity {quantityType}.");
        }

        /// <summary>
        ///     Try to dynamically parse a quantity string representation.
        /// </summary>
        /// <param name="quantityType">Type of quantity, such as <see cref="Length"/>.</param>
        /// <param name="quantityString">Quantity string representation, such as "1.5 kg". Must be compatible with given quantity type.</param>
        /// <returns>The parsed quantity.</returns>
        public static bool TryParse(Type quantityType, string quantityString, out IQuantity quantity)
        {
            quantity = default(IQuantity);

            if (!typeof(IQuantity).IsAssignableFrom(quantityType))
                return false;

            var parser = QuantityParser.Default;

"@; foreach ($quantity in $quantities) {
  $quantityName = $quantity.Name;@"
            if (quantityType == typeof($quantityName))
                return parser.TryParse<$quantityName, $($quantityName)Unit>(quantityString, null, $quantityName.From, out quantity);

"@; }@"
            throw new ArgumentException(
                $"Type {quantityType} is not a known quantity type. Did you pass in a third-party quantity type defined outside UnitsNet library?");
        }

        /// <summary>
        ///     Get information about the given quantity type.
        /// </summary>
        /// <param name="quantityType">The quantity type enum value.</param>
        /// <returns>Information about the quantity and its units.</returns>
        public static QuantityInfo GetInfo(QuantityType quantityType)
        {
            return UnitsHelper.QuantityInfos.First(qi => qi.QuantityType == quantityType);
        }
    }
}
"@;
}

function toCamelCase([string] $str) {
    return [char]::ToLower($str[0]) + $str.Substring(1)
}
