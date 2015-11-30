// File: SortByTypeThenCost.cs
// By: Nick Wolf
// This class provides an IComparer for the Parcel class
// that orders the objects Type and Cost in reverse natural order.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class SortByTypeThenCost : IComparer<Parcel>
{
    // Precondition:  None
    // Postcondition: When t1 < t2, method returns negative #
    //                When t1 == t2, method returns zero
    //                When t1 > t2, method returns positive #
    public int Compare(Parcel p1, Parcel p2)
    {

        if (p1.GetType().ToString() != p2.GetType().ToString()) // Check for Type difference first
            return p1.GetType().ToString().CompareTo(p2.GetType().ToString());
        else
            return p2.CalcCost().CompareTo(p1.CalcCost());
    }
}