// File: OrderByDesZip.cs
// By: Nick Wolf
// This class provides an IComparer for the Parcel class
// that orders the objects zip in reverse natural order.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


class OrderByDesZip : IComparer<Parcel>
{
    // Precondition:  None
    // Postcondition: When t1 < t2, method returns negative #
    //                When t1 == t2, method returns zero
    //                When t1 > t2, method returns positive #
    public int Compare(Parcel p1, Parcel p2)
    {
        if (p1 == null && p2 == null)
            return 0;
        if (p2 == null)
            return -1;

        return p2.DestinationAddress.Zip.CompareTo(p1.DestinationAddress.Zip);
    }
}