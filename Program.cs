using HotelBookingAPI.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// 1. Register DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// 2. Enable Controllers (this is MISSING in your version)
builder.Services.AddControllers();  // <-- Needed for routing to controllers

// 3. Add Swagger/OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// 4. OPTIONAL: CORS for MVC frontend (if calling API from browser)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// 5. Build the app
var app = builder.Build();

// 6. Use Swagger only in development
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// 7. Enable HTTPS redirection
app.UseHttpsRedirection();

// 8. Enable Authorization if needed
app.UseAuthorization();

// 9. Enable CORS
app.UseCors("AllowAll");

// 10. Map routes to controllers
app.MapControllers();  

// 11. Start the app
app.Run();
