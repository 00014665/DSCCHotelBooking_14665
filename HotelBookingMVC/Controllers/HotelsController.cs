using HotelBookingAPI.HotelBookingMVC.Models;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Net.Http.Json;

public class HotelsController : Controller
{
    private readonly IHttpClientFactory _clientFactory;

    public HotelsController(IHttpClientFactory clientFactory)
    {
        _clientFactory = clientFactory;
    }

    // GET: /Hotels
    public async Task<IActionResult> Index()
    {
        var client = _clientFactory.CreateClient("HotelAPI");
        var hotels = await client.GetFromJsonAsync<List<Hotel>>("Hotels");
        return View(hotels);
    }

    // GET: /Hotels/Create
    public IActionResult Create() => View();

    // POST: /Hotels/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Hotel hotel)
    {
        if (!ModelState.IsValid) return View(hotel);

        var client = _clientFactory.CreateClient("HotelAPI");
        var response = await client.PostAsJsonAsync("Hotels", hotel);
        return response.IsSuccessStatusCode ? RedirectToAction(nameof(Index)) : View(hotel);
    }

    // GET: /Hotels/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var client = _clientFactory.CreateClient("HotelAPI");
        var hotel = await client.GetFromJsonAsync<Hotel>($"Hotels/{id}");
        return hotel == null ? NotFound() : View(hotel);
    }

    // POST: /Hotels/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Hotel hotel)
    {
        if (id != hotel.HotelId || !ModelState.IsValid)
            return View(hotel);

        var client = _clientFactory.CreateClient("HotelAPI");
        var response = await client.PutAsJsonAsync($"Hotels/{id}", hotel);
        return response.IsSuccessStatusCode ? RedirectToAction(nameof(Index)) : View(hotel);
    }

    // GET: /Hotels/Delete/5
    public async Task<IActionResult> Delete(int id)
    {
        var client = _clientFactory.CreateClient("HotelAPI");
        var hotel = await client.GetFromJsonAsync<Hotel>($"Hotels/{id}");
        return hotel == null ? NotFound() : View(hotel);
    }

    // POST: /Hotels/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        var client = _clientFactory.CreateClient("HotelAPI");
        var response = await client.DeleteAsync($"Hotels/{id}");
        return response.IsSuccessStatusCode ? RedirectToAction(nameof(Index)) : Problem("Delete failed.");
    }
}
