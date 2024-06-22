using System.Security.Cryptography.X509Certificates;
using System.Text.Json;
using System.Text.Json.Serialization;
using KubeOps.Operator.Web.Builder;
using KubeOps.Operator.Web.Certificates;
using KubeOps.Operator.Web.Webhooks.Admission;

namespace Borg.KubeOperator.Web
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            //string ip = "192.168.1.100";
            //ushort port = 443;
            //CertificateGenerator generator = new CertificateGenerator(ip);
            //X509Certificate2 cert = generator.Server.CopyServerCertWithPrivateKey();

            builder.WebHost.ConfigureKestrel(serverOptions =>
            {
                serverOptions.Listen(System.Net.IPAddress.Any, 8080);

                //serverOptions.Listen(System.Net.IPAddress.Any, port, listenOptions =>
                //{
                //    listenOptions.UseHttps(cert);
                //});
            });

            builder
                .Services
                .AddBorgOperator();

            //builder.Services
            //    .AddBorgOperator()
            //    .UseCertificateProvider(port, ip, generator);

            builder
                .Services
                .AddControllers();

            var app = builder.Build();

            app.UseRouting();
            app.MapControllers();

            app.MapGet("/service/healthz", () => Results.Ok());
            app.MapGet("/service/ready", () => Results.Ok());
            app.MapGet("/service/startup", () => Results.Ok());

            app.Run();
        }
    }
}
