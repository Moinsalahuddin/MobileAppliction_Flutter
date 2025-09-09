// Sample Data for City Guide App
// Copy and paste this data into your Firestore Console

// ========================================
// CITIES COLLECTION
// ========================================

// Document ID: new-york
{
  "id": "new-york",
  "name": "New York City",
  "description": "The Big Apple - a vibrant metropolis with endless attractions, world-class restaurants, and iconic landmarks.",
  "imageUrl": "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "country": "United States",
  "population": 8336817,
  "attractions": ["statue-of-liberty", "central-park", "times-square", "empire-state"],
  "isActive": true
}

// Document ID: london
{
  "id": "london",
  "name": "London",
  "description": "Historic capital of England with royal palaces, world-famous museums, and diverse culture.",
  "imageUrl": "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800",
  "latitude": 51.5074,
  "longitude": -0.1278,
  "country": "United Kingdom",
  "population": 8982000,
  "attractions": ["big-ben", "tower-bridge", "british-museum", "buckingham-palace"],
  "isActive": true
}

// Document ID: paris
{
  "id": "paris",
  "name": "Paris",
  "description": "The City of Light - famous for art, fashion, gastronomy, and culture.",
  "imageUrl": "https://images.unsplash.com/photo-1502602898534-47d3c0c0b8a9?w=800",
  "latitude": 48.8566,
  "longitude": 2.3522,
  "country": "France",
  "population": 2161000,
  "attractions": ["eiffel-tower", "louvre-museum", "notre-dame", "arc-de-triomphe"],
  "isActive": true
}

// Document ID: tokyo
{
  "id": "tokyo",
  "name": "Tokyo",
  "description": "Ultra-modern city blending cutting-edge technology with traditional Japanese culture.",
  "imageUrl": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800",
  "latitude": 35.6762,
  "longitude": 139.6503,
  "country": "Japan",
  "population": 13929286,
  "attractions": ["tokyo-tower", "sensoji-temple", "shibuya-crossing", "tsukiji-market"],
  "isActive": true
}

// ========================================
// ATTRACTIONS COLLECTION
// ========================================

// Document ID: statue-of-liberty
{
  "id": "statue-of-liberty",
  "name": "Statue of Liberty",
  "description": "Iconic symbol of freedom and democracy, standing 305 feet tall on Liberty Island.",
  "cityId": "new-york",
  "category": "touristAttraction",
  "imageUrls": [
    "https://images.unsplash.com/photo-1548013146-72479768bada?w=800",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800"
  ],
  "latitude": 40.6892,
  "longitude": -74.0445,
  "address": "Liberty Island, New York, NY 10004",
  "phoneNumber": "+1-212-363-3200",
  "website": "https://www.nps.gov/stli/",
  "openingHours": "9:00 AM - 5:00 PM",
  "averageRating": 4.5,
  "totalReviews": 1250,
  "priceRange": 3.0,
  "tags": ["landmark", "monument", "history", "freedom"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// Document ID: central-park
{
  "id": "central-park",
  "name": "Central Park",
  "description": "843-acre urban oasis in the heart of Manhattan with walking trails, lakes, and cultural attractions.",
  "cityId": "new-york",
  "category": "park",
  "imageUrls": [
    "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
  ],
  "latitude": 40.7829,
  "longitude": -73.9654,
  "address": "Central Park, New York, NY",
  "phoneNumber": "+1-212-310-6600",
  "website": "https://www.centralparknyc.org/",
  "openingHours": "6:00 AM - 10:00 PM",
  "averageRating": 4.7,
  "totalReviews": 2100,
  "priceRange": 1.0,
  "tags": ["park", "nature", "recreation", "free"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// Document ID: times-square
{
  "id": "times-square",
  "name": "Times Square",
  "description": "Famous intersection known for its bright lights, Broadway theaters, and New Year's Eve ball drop.",
  "cityId": "new-york",
  "category": "touristAttraction",
  "imageUrls": [
    "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800",
    "https://images.unsplash.com/photo-1534430480872-3498386e7856?w=800"
  ],
  "latitude": 40.7580,
  "longitude": -73.9855,
  "address": "Times Square, New York, NY 10036",
  "phoneNumber": "",
  "website": "https://www.timessquarenyc.org/",
  "openingHours": "24/7",
  "averageRating": 4.2,
  "totalReviews": 890,
  "priceRange": 1.0,
  "tags": ["landmark", "lights", "broadway", "free"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// Document ID: big-ben
{
  "id": "big-ben",
  "name": "Big Ben",
  "description": "Famous clock tower at the north end of the Houses of Parliament, symbol of London.",
  "cityId": "london",
  "category": "touristAttraction",
  "imageUrls": [
    "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800",
    "https://images.unsplash.com/photo-1502602898534-47d3c0c0b8a9?w=800"
  ],
  "latitude": 51.4994,
  "longitude": -0.1245,
  "address": "Houses of Parliament, London SW1A 0AA, UK",
  "phoneNumber": "+44-20-7219-3000",
  "website": "https://www.parliament.uk/",
  "openingHours": "Viewing from outside only",
  "averageRating": 4.4,
  "totalReviews": 1560,
  "priceRange": 1.0,
  "tags": ["landmark", "clock", "parliament", "free"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// Document ID: eiffel-tower
{
  "id": "eiffel-tower",
  "name": "Eiffel Tower",
  "description": "Iconic iron lattice tower on the Champ de Mars, symbol of Paris and France.",
  "cityId": "paris",
  "category": "touristAttraction",
  "imageUrls": [
    "https://images.unsplash.com/photo-1502602898534-47d3c0c0b8a9?w=800",
    "https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=800"
  ],
  "latitude": 48.8584,
  "longitude": 2.2945,
  "address": "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France",
  "phoneNumber": "+33-892-70-12-39",
  "website": "https://www.toureiffel.paris/",
  "openingHours": "9:00 AM - 11:45 PM",
  "averageRating": 4.6,
  "totalReviews": 3200,
  "priceRange": 4.0,
  "tags": ["landmark", "tower", "romance", "views"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// ========================================
// RESTAURANTS
// ========================================

// Document ID: le-bernardin
{
  "id": "le-bernardin",
  "name": "Le Bernardin",
  "description": "World-renowned seafood restaurant with three Michelin stars, offering exceptional French cuisine.",
  "cityId": "new-york",
  "category": "restaurant",
  "imageUrls": [
    "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800"
  ],
  "latitude": 40.7614,
  "longitude": -73.9776,
  "address": "155 W 51st St, New York, NY 10019",
  "phoneNumber": "+1-212-554-1515",
  "website": "https://www.le-bernardin.com/",
  "openingHours": "5:30 PM - 10:30 PM",
  "averageRating": 4.8,
  "totalReviews": 450,
  "priceRange": 5.0,
  "tags": ["fine-dining", "seafood", "french", "michelin"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// Document ID: shibuya-crossing
{
  "id": "shibuya-crossing",
  "name": "Shibuya Crossing",
  "description": "Famous pedestrian scramble crossing, one of the busiest intersections in the world.",
  "cityId": "tokyo",
  "category": "touristAttraction",
  "imageUrls": [
    "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800",
    "https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=800"
  ],
  "latitude": 35.6595,
  "longitude": 139.7004,
  "address": "Shibuya, Tokyo 150-0002, Japan",
  "phoneNumber": "",
  "website": "",
  "openingHours": "24/7",
  "averageRating": 4.3,
  "totalReviews": 780,
  "priceRange": 1.0,
  "tags": ["crossing", "pedestrian", "busy", "free"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// ========================================
// HOTELS
// ========================================

// Document ID: ritz-paris
{
  "id": "ritz-paris",
  "name": "The Ritz Paris",
  "description": "Luxury 5-star hotel in the heart of Paris, known for its elegance and exceptional service.",
  "cityId": "paris",
  "category": "hotel",
  "imageUrls": [
    "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800"
  ],
  "latitude": 48.8674,
  "longitude": 2.3295,
  "address": "15 Place Vendôme, 75001 Paris, France",
  "phoneNumber": "+33-1-43-16-30-30",
  "website": "https://www.ritzparis.com/",
  "openingHours": "24/7",
  "averageRating": 4.9,
  "totalReviews": 320,
  "priceRange": 5.0,
  "tags": ["luxury", "5-star", "historic", "elegant"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// ========================================
// MUSEUMS
// ========================================

// Document ID: louvre-museum
{
  "id": "louvre-museum",
  "name": "Louvre Museum",
  "description": "World's largest art museum, home to the Mona Lisa and thousands of other masterpieces.",
  "cityId": "paris",
  "category": "museum",
  "imageUrls": [
    "https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800",
    "https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800"
  ],
  "latitude": 48.8606,
  "longitude": 2.3376,
  "address": "Rue de Rivoli, 75001 Paris, France",
  "phoneNumber": "+33-1-40-20-50-50",
  "website": "https://www.louvre.fr/",
  "openingHours": "9:00 AM - 6:00 PM (Closed Tuesdays)",
  "averageRating": 4.7,
  "totalReviews": 2800,
  "priceRange": 3.0,
  "tags": ["museum", "art", "mona-lisa", "culture"],
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}

// ========================================
// SAMPLE REVIEWS
// ========================================

// Document ID: review-1
{
  "id": "review-1",
  "attractionId": "statue-of-liberty",
  "userId": "user-1",
  "userName": "John Smith",
  "userProfileImage": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
  "rating": 5.0,
  "comment": "Absolutely breathtaking! The ferry ride to the island was great and the views of Manhattan from the crown are incredible. A must-visit when in NYC.",
  "images": [],
  "likes": 12,
  "likedBy": ["user-2", "user-3"],
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}

// Document ID: review-2
{
  "id": "review-2",
  "attractionId": "central-park",
  "userId": "user-2",
  "userName": "Sarah Johnson",
  "userProfileImage": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100",
  "rating": 4.5,
  "comment": "Beautiful park with so much to see and do. Perfect for walking, cycling, or just relaxing. The Bethesda Fountain is stunning.",
  "images": [],
  "likes": 8,
  "likedBy": ["user-1"],
  "createdAt": "2024-01-20T14:15:00Z",
  "updatedAt": "2024-01-20T14:15:00Z"
}

// Document ID: review-3
{
  "id": "review-3",
  "attractionId": "eiffel-tower",
  "userId": "user-3",
  "userName": "Michael Brown",
  "userProfileImage": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
  "rating": 4.8,
  "comment": "The Eiffel Tower is even more impressive in person. The evening light show is magical. Book tickets in advance to avoid long queues.",
  "images": [],
  "likes": 15,
  "likedBy": ["user-1", "user-2", "user-4"],
  "createdAt": "2024-01-25T19:45:00Z",
  "updatedAt": "2024-01-25T19:45:00Z"
}

// ========================================
// SAMPLE USERS (ADMIN)
// ========================================

// Document ID: admin-user
{
  "id": "admin-user",
  "email": "admin@cityguide.com",
  "name": "Admin User",
  "profileImageUrl": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
  "phoneNumber": "+1-555-0123",
  "favoriteAttractions": ["statue-of-liberty", "central-park"],
  "isAdmin": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "lastLoginAt": "2024-01-30T12:00:00Z"
}

// Document ID: user-1
{
  "id": "user-1",
  "email": "john.smith@email.com",
  "name": "John Smith",
  "profileImageUrl": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
  "phoneNumber": "+1-555-0001",
  "favoriteAttractions": ["statue-of-liberty", "times-square"],
  "isAdmin": false,
  "createdAt": "2024-01-10T00:00:00Z",
  "lastLoginAt": "2024-01-30T10:30:00Z"
}

// Document ID: user-2
{
  "id": "user-2",
  "email": "sarah.johnson@email.com",
  "name": "Sarah Johnson",
  "profileImageUrl": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100",
  "phoneNumber": "+1-555-0002",
  "favoriteAttractions": ["central-park", "big-ben"],
  "isAdmin": false,
  "createdAt": "2024-01-12T00:00:00Z",
  "lastLoginAt": "2024-01-30T09:15:00Z"
} 