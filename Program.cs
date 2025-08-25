using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
var newRelicKey = Environment.GetEnvironmentVariable("NEW_RELIC_LICENSE_KEY");
var newRelicAppName = Environment.GetEnvironmentVariable("NEW_RELIC_APP_NAME");

if (!string.IsNullOrEmpty(newRelicKey))
{
    Console.WriteLine($"New Relic Agent ativado para o app: {newRelicAppName}");
    // Aqui voc� poderia inicializar o agente via API do New Relic, se necess�rio
}

// Swagger p/ minimal APIs em .NET 8
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "DockerNewRelicDemo API",
        Version = "v1"
    });
});

var app = builder.Build();


app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "DockerNewRelicDemo API v1");
    c.RoutePrefix = "swagger"; // acessa em /swagger
});

app.UseHttpsRedirection();

var summaries = new[]
{
    "Developer", "Assistant", "Human Resources", "DevOps", "Receptionist"
};

var names = new[]
{
    "John", "Peter", "Robert", "Willian", "Antony", "Charlote", "Ana", "Marina", "Maria", "Mary"
};

app.MapGet("/getRandomEmployee", () =>
{
    var result = Enumerable.Range(1, 5).Select(_ =>
        new RandomInfo(
            names[Random.Shared.Next(names.Length)],
            Random.Shared.Next(18, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();

    return Results.Ok(result);
})
.WithName("GetRandomEmployee")
.WithOpenApi(); // garante que aparece no Swagger

app.Run();

record RandomInfo(string Name, int Age, string? Summary);
