using System;
using System.Data;
using Microsoft.AnalysisServices.AdomdClient;
using System.Data.SqlClient;

namespace TestExample
{
    public interface ITabularHelper
    {
        DataTable GetDataTable(string query);
        void ProcessDatabase();
    }

    public class TabularHelper:ITabularHelper
    {
        private string asConnectionString;
        public TabularHelper(string asConnectionString)
        {
            this.asConnectionString = asConnectionString;
        }

        public DataTable GetDataTable(string query)
        {
            using (AdomdConnection con = new AdomdConnection(asConnectionString))
            {
                con.Open();
                using (AdomdDataAdapter adapter = new AdomdDataAdapter(query, con))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    return dataTable;
                }
            }
        }

        public void ProcessDatabase()
        {
            using (AdomdConnection con = new AdomdConnection(asConnectionString))
            {
                con.Open();

                string processCommandText = @"
                    {
                      ""refresh"": {
                        ""type"": ""full"",
                        ""objects"": [
                          {
                            ""database"": ""TabularExample""
                          }
                        ]
                      }
                    }
                    ";
                using (AdomdCommand command = new AdomdCommand(processCommandText, con))
                {
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
