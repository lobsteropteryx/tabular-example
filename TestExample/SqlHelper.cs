using System;
using System.Data;
using System.Data.SqlClient;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace TestExample
{
    public interface ISqlHelper
    {
        void InsertPersons(Table table);
    }

    [Binding]
    public class SqlHelper : ISqlHelper
    {
        private string connectionString;
        public SqlHelper(string connectionString)
        {
            this.connectionString = connectionString;
        }

        public void InsertPersons(Table table)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                var deleteCommand = new SqlCommand("DELETE FROM dbo.person", conn);
                deleteCommand.ExecuteNonQuery();

                SqlCommand insertCommand = new SqlCommand(@"
                    INSERT INTO dbo.person 
                    (name, age) 
                    VALUES (@name, @age)", conn);

                insertCommand.Parameters.Add("@name", SqlDbType.VarChar);
                insertCommand.Parameters.Add("@age", SqlDbType.Int);

                var rows = table.CreateSet<Person>();
                foreach (Person row in rows)
                {
                    insertCommand.Parameters["@name"].Value = row.Name;
                    insertCommand.Parameters["@age"].Value = row.Age;
                    insertCommand.ExecuteNonQuery();
                }

                conn.Close();
            }
        }
    }

    class Person
    {
        public string Name { get; set; }
        public int Age { get; set; }
    }
}
