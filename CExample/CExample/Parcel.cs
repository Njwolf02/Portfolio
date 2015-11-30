// Program 0
// CIS 200-10
// Summer 2015
// Due: 5/21/2015
// By: Andrew L. Wright & Nick Wolf

// File: Parcel.cs
// Parcel serves as the abstract base class of the Parcel hierachy.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public abstract class Parcel : IComparable<Parcel>
{
    // Precondition:  None
    // Postcondition: The parcel is created with the specified values for
    //                origin address and destination address
    public Parcel(Address originAddress, Address destAddress)
    {
        OriginAddress = originAddress;
        DestinationAddress = destAddress;
    }

    public Address OriginAddress
    {
        // Precondition:  None
        // Postcondition: The parcel's origin address has been returned
        get;

        // Precondition:  None
        // Postcondition: The parcel's origin address has been set to the
        //                specified value
        set;
    }

    public Address DestinationAddress
    {
        // Precondition:  None
        // Postcondition: The parcel's destination address has been returned
        get;

        // Precondition:  None
        // Postcondition: The parcel's destination address has been set to the
        //                specified value
        set;
    }

    // Precondition:  None
    // Postcondition: The parcel's cost has been returned
    public abstract decimal CalcCost();

    // Precondition:  None
    // Postcondition: A String with the parcel's data has been returned
    public override String ToString()
    {
        return String.Format("Origin Address:{3}{0}{3}{3}Destination Address:{3}{1}{3}Cost: {2:C}",
            OriginAddress, DestinationAddress, CalcCost(), Environment.NewLine);
    }

    // Precondition:  None
    // Postcondition: When this < p1, method returns negative #
    //                When this == p1, method returns zero
    //                When this > p1, method returns positive #
    public int CompareTo(Parcel p1)
    {
        // Implements correct handling of null values (in .NET, null less than anything)
        if (this == null && p1 == null) // Both null?
            return 0;

        if (this == null) // only this is null?
            return -1;

        if (p1 == null) // only t2 is null?
            return 1;

        decimal costCompare = this.CalcCost() - p1.CalcCost(); // Cost difference?

        if (costCompare != 0)
            return this.CalcCost().CompareTo(p1.CalcCost());
        else return 0;
    }
}
