using FileServices.Api.Services;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "FileServices", Version = "v1" });
});
// Configure file upload settings
builder.Services.Configure<IISServerOptions>(options =>
{
    options.MaxRequestBodySize = 2*100 * 1024 * 1024; // 100 MB
});

// Add file service
builder.Services.AddScoped<IFileService, FileService>();

// Configure CORS
builder.Services.AddCors(options => options.AddPolicy("Cors", policy =>
{
    policy
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .WithExposedHeaders("*")
    .AllowAnyHeader();
}));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
}
app.UseSwagger();
app.UseSwaggerUI(c => c.SwaggerEndpoint("../swagger/v1/swagger.json", "FileServices v1"));
app.UseHttpsRedirection();
app.UseCors("Cors");
app.UseAuthorization();
app.MapControllers();

// Ensure uploads directory exists
var uploadsPath = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
if (!Directory.Exists(uploadsPath))
{
    Directory.CreateDirectory(uploadsPath);
}

app.Run();
