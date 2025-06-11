namespace HotelBookingAPI.Models
{
    public class Room
    {
        public int RoomId { get; set; }
        public int HotelId { get; set; }
        public string RoomNumber { get; set; }
        public string RoomType { get; set; }
        public decimal PricePerNight { get; set; }
        public bool IsAvailable { get; set; }

        public Hotel Hotel { get; set; }
        public ICollection<Booking> Bookings { get; set; }
    }

}
