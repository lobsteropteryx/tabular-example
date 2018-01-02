using NUnit.Framework;
using System;
using System.Data;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace TestExample
{
    [Binding]
    public class AverageAgeSteps
    {
        private ISqlHelper _sqlHelper;
        private ITabularHelper _tabularHelper;
        DataTable dataTable;

        public AverageAgeSteps(ISqlHelper sqlHelper, ITabularHelper tabularHelper)
        {
            this._sqlHelper = sqlHelper;
            this._tabularHelper = tabularHelper;
        }

        [Given(@"I have persons:")]
        public void GivenIHavePersons(Table table)
        {
            _sqlHelper.InsertPersons(table);
            _tabularHelper.ProcessDatabase();
        }
        
        [When(@"I query for average age")]
        public void WhenIQueryForAverageAge()
        {
            var query = @"EVALUATE ROW(""Average Age"", Person[Average Age])";
            this.dataTable = _tabularHelper.GetDataTable(query);
        }
        
        [Then(@"I expect the result to be:")]
        public void ThenIExpectTheResultToBe(Table table)
        {
            int index = 0;
            var expectedRows = table.CreateSet<AverageAge>();
            foreach (AverageAge expectedRow in expectedRows)
            {
                DataRow row = this.dataTable.Rows[index++];
                Assert.AreEqual(expectedRow.Average, row["[Average Age]"]);
            }
        }
    }

    class AverageAge
    {
        public double Average { get; set; }
    }
}
