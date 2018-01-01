using BoDi;
using System;
using TechTalk.SpecFlow;

namespace TestExample
{
    [Binding]
    public class ConnectionSupport
    {
        private readonly IObjectContainer objectContainer;

        public ConnectionSupport(IObjectContainer objectContainer)
        {
            this.objectContainer = objectContainer;
        }

        [BeforeScenario]
        public void InitializeConnection()
        {
            var sqlConnectionString = Environment.GetEnvironmentVariable("TabularAcceptanceTestSqlConnectionString");
            var analysisServicersConnectionString = Environment.GetEnvironmentVariable("TabularAcceptanceTestAnalysisServicesConnectionString");
            var tabularHelper = new TabularHelper(analysisServicersConnectionString);
            var sqlHelper = new SqlHelper(sqlConnectionString);
            objectContainer.RegisterInstanceAs<ITabularHelper>(tabularHelper);
            objectContainer.RegisterInstanceAs<ISqlHelper>(sqlHelper);
        }
    }
}
