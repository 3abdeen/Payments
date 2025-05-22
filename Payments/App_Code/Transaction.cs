using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class Transaction
{
    public int TransactionID { get; set; }
    public int UserID { get; set; }
    public decimal Amount { get; set; }
    public DateTime TransactionDate { get; set; }
    public string Description { get; set; }
    public string Status { get; set; }
    public string Reference { get; set; }
}