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
using System.Diagnostics.CodeAnalysis;
using UnitsNet.Units;
using Xunit;

namespace UnitsNet.Tests
{
    public class QuantityInfoTest
    {
        [Fact]
        public void Constructor_AssignsProperties()
        {
            var expectedZero = Length.FromCentimeters(10);
            var expectedUnits = new Enum[] {LengthUnit.Centimeter, LengthUnit.Kilometer};
            var expectedQuantityType = QuantityType.Length;

            var info = new QuantityInfo(expectedQuantityType, expectedUnits, expectedZero);

            Assert.Equal(expectedZero, info.Zero);
            Assert.Equal("Length", info.Name);
            Assert.Equal(expectedUnits, info.Units);
            Assert.Equal(new[]{"Centimeter", "Kilometer"}, info.UnitNames);
            Assert.Equal(expectedQuantityType, info.QuantityType);
        }

        [Fact]
        public void GenericsConstructor_AssignsProperties()
        {
            var expectedZero = Length.FromCentimeters(10);
            var expectedUnits = new[] {LengthUnit.Centimeter, LengthUnit.Kilometer};
            var expectedQuantityType = QuantityType.Length;

            var info = new QuantityInfo<LengthUnit>(expectedQuantityType, expectedUnits, expectedZero);

            Assert.Equal(expectedZero, info.Zero);
            Assert.Equal("Length", info.Name);
            Assert.Equal(expectedUnits, info.Units);
            Assert.Equal(new[]{"Centimeter", "Kilometer"}, info.UnitNames);
            Assert.Equal(expectedQuantityType, info.QuantityType);
        }

        [Fact]
        [SuppressMessage("ReSharper", "AssignNullToNotNullAttribute")]
        public void Constructor_GivenNullAsUnits_ThrowsArgumentNullException()
        {
            Assert.Throws<ArgumentNullException>(() => new QuantityInfo(QuantityType.Length, null, null));
        }

        [Fact]
        [SuppressMessage("ReSharper", "AssignNullToNotNullAttribute")]
        public void GenericsConstructor_GivenNullAsUnits_ThrowsArgumentNullException()
        {
            Assert.Throws<ArgumentNullException>(() => new QuantityInfo<LengthUnit>(QuantityType.Length, null, null));
        }

        [Fact]
        [SuppressMessage("ReSharper", "AssignNullToNotNullAttribute")]
        public void Constructor_GivenNullAsZero_ThrowsArgumentNullException()
        {
            Assert.Throws<ArgumentNullException>(() => new QuantityInfo(QuantityType.Length, new Enum[0], null));
        }

        [Fact]
        [SuppressMessage("ReSharper", "AssignNullToNotNullAttribute")]
        public void GenericsConstructor_GivenNullAsZero_ThrowsArgumentNullException()
        {
            Assert.Throws<ArgumentNullException>(() => new QuantityInfo<LengthUnit>(QuantityType.Length, new LengthUnit[0], null));
        }
    }
}