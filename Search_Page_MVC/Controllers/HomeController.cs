using MySqlConnector;
using Search_Page_MVC.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Search_Page_MVC.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            List<Customer> dummy = new List<Customer>();
            dummy.Add(new Customer());
            return View(dummy);
        }

        [HttpPost]
        public JsonResult AjaxMethod(int pageIndex, string searchTerm)
        {
            CustomerModel model = new CustomerModel();
            model.SearchTerm = searchTerm;
            model.PageIndex = pageIndex;
            model.PageSize = 10;

            List<Customer> customers = new List<Customer>();
            string constring = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (MySqlConnection con = new MySqlConnection(constring))
            {
                using (MySqlCommand cmd = new MySqlCommand("GetCustomersPageSearch", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SearchTerm", model.SearchTerm);
                    cmd.Parameters.AddWithValue("@PageIndex", model.PageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", model.PageSize);
                    cmd.Parameters.Add("@RecordCount", MySqlDbType.VarChar, 30);
                    cmd.Parameters["@RecordCount"].Direction = ParameterDirection.Output;
                    con.Open();
                    MySqlDataReader sdr = cmd.ExecuteReader();
                    while (sdr.Read())
                    {
                        customers.Add(new Customer
                        {
                            CustomerID = sdr["CustomerID"].ToString(),
                            ContactName = sdr["ContactName"].ToString(),
                            City = sdr["City"].ToString(),
                            Country = sdr["Country"].ToString()
                        });
                    }
                    con.Close();

                    model.Customers = customers;
                    model.RecordCount = Convert.ToInt32(cmd.Parameters["@RecordCount"].Value);
                }
            }

            return Json(model);
        }
    }
}