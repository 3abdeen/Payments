using System;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web;

public static class PempoHelper
{
    private static readonly HttpClient client = new HttpClient();
    private static readonly string apiKey = ConfigurationManager.AppSettings["PaymobApiKey"];
    private static readonly string authUrl = ConfigurationManager.AppSettings["PaymobAuthUrl"];
    private static readonly string orderUrl = ConfigurationManager.AppSettings["PaymobOrderUrl"];
    private static readonly string paymentKeyUrl = ConfigurationManager.AppSettings["PaymobPaymentKeyUrl"];
    private static readonly string iframeUrl = ConfigurationManager.AppSettings["PaymobIframeUrl"];

    public static bool ProcessPayment(decimal amount, string currencyCode, string description)
    {
        try
        {
            var authToken = GetAuthToken().Result;
            var orderId = CreateOrder(authToken, amount, currencyCode, description).Result;
            var paymentToken = GetPaymentKey(authToken, orderId, amount, currencyCode).Result;
            var paymentUrl = iframeUrl
                .Replace("{iframe_id}", "YOUR_IFRAME_ID")
                .Replace("{payment_token}", paymentToken);

            HttpContext.Current.Response.Redirect(paymentUrl);
            return true;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Payment error: {ex.Message}");
            return false;
        }
    }

    private static async Task<string> GetAuthToken()
    {
        var request = new
        {
            api_key = apiKey
        };

        var content = new StringContent(JsonSerializer.Serialize(request), Encoding.UTF8, "application/json");
        var response = await client.PostAsync(authUrl, content);
        response.EnsureSuccessStatusCode();

        var responseBody = await response.Content.ReadAsStringAsync();
        return JsonDocument.Parse(responseBody).RootElement.GetProperty("token").GetString();
    }

    private static async Task<string> CreateOrder(string authToken, decimal amount, string currency, string description)
    {
        var request = new
        {
            auth_token = authToken,
            delivery_needed = "false",
            amount_cents = amount * 100,
            currency = currency,
            items = new[]
            {
                new
                {
                    name = description,
                    amount_cents = amount * 100,
                    description = description,
                    quantity = "1"
                }
            }
        };

        var content = new StringContent(JsonSerializer.Serialize(request), Encoding.UTF8, "application/json");
        var response = await client.PostAsync(orderUrl, content);
        response.EnsureSuccessStatusCode();

        var responseBody = await response.Content.ReadAsStringAsync();
        return JsonDocument.Parse(responseBody).RootElement.GetProperty("id").GetString();
    }

    private static async Task<string> GetPaymentKey(string authToken, string orderId, decimal amount, string currency)
    {
        var request = new
        {
            auth_token = authToken,
            amount_cents = amount * 100,
            expiration = 3600,
            order_id = orderId,
            billing_data = new
            {
                first_name = "Customer",
                last_name = "Name",
                email = "customer@example.com",
                phone_number = "+201010101010",
                country = "EG",
                city = "Cairo",
                street = "Street",
                building = "Building"
            },
            currency = currency,
            integration_id = 1 // integration ID from Paymob
        };

        var content = new StringContent(JsonSerializer.Serialize(request), Encoding.UTF8, "application/json");
        var response = await client.PostAsync(paymentKeyUrl, content);
        response.EnsureSuccessStatusCode();

        var responseBody = await response.Content.ReadAsStringAsync();
        return JsonDocument.Parse(responseBody).RootElement.GetProperty("token").GetString();
    }
}