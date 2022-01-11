1. Registration API:
POST /skin/rest/V1/customers HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: 6324f07d-e163-44a4-bd32-04224e52e58f
{
    "customer": {
        "email": "sukumar@sharplogician.com",
        "firstname": "Sukumar",
        "lastname": "Gorai"
    },
    "password": "admin#123"
}

Return: Customer Details after registration.

====================================================================


2. Login API:
POST /skin/rest/V1/integration/customer/token HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: 503efb8b-a4e8-4c01-9470-780306426561
{
	"username":"sukumar@sharplogician.com",
	"password":"admin#123"
}

Return: "d9v54kfrzn4sfotulqco20xm8p0kshax"(Customer Access Token).

====================================================================

3. Reset Password API:

====================================================================


4. Update Password API:
PUT /skin/rest/V1/customers/me/password?customerId=5 HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: ac9e8136-3875-46d4-93bd-697106c1ee08
{
  "currentPassword": "Admin#123",
  "newPassword": "admin#123"
}

Return true/false

====================================================================

5. Search Wallpaper API:
GET /skin/rest/V1/wallpaper/search-images?query=Test HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: b9b447ad-e781-4d4e-a3f6-12eecffaf81a

Return: List of images which matches search query.

====================================================================

6. Category Listing API:
GET /skin/rest/V1/wallpaper/get-categories? HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 16ff9ded-070e-43a4-b2e6-69f13e0f24e2

Return: List of categories.

====================================================================

7. Wallpaper Listing API:
GET /skin/rest/V1/wallpaper/get-images HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: cb763d08-5b01-406d-8244-9f3c44bb491d

Return: List of wallpapers.

====================================================================

8. Wallpaper Listing by Category ID API:
GET /skin/rest/V1/wallpaper/get-images?category_id = 1 HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 88969de5-b011-457f-ad92-8fd3d8ed30f6

Return: List of wallpapers associated with requested category ID.

====================================================================

9. Wallpaper Listing with Sorting, Page, Limit API:
GET /skin/rest/V1/wallpaper/get-images?order_by=description&order_direction=DESC&paginate=true&limit=1&offset=1 HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 90eb0851-fe1d-45db-abdc-e0de34d13a53

Return: List of wallpapers with requested sort order, sort direction, limit and page.

====================================================================

10. Predesgined Categories API:
GET /skin/rest/V1/wallpaper/get-predesigned-categories HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 29c82d35-c436-47cb-b37f-535087eab944

Return: List of PreDesigned Categories.

====================================================================

11. PreDesigned Wallpaper Listing API:
GET /skin/rest/V1/wallpaper/get-images?type=prodesigned HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: c5956911-12ad-43ed-b74a-4fe0300beed9

Return: List of predesigned wallpapers.

====================================================================

12. List of Wallpaper Options API:
GET /skin/rest/V1/wallpaper/get-options HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 2c2d94f9-e814-4dbd-8523-e4bc9700aee2

Return: List if options for wallpapers.

====================================================================

13. Create Quote API:
POST /skin/rest/V1/carts/mine? HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
cache-control: no-cache
Postman-Token: 958aede0-4771-475b-9a36-9b1fa10ebcfc

return: 62(Quote ID).

====================================================================

14. Adding Product to Cart API:
POST /skin/rest/V1/carts/mine/items? HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
{
  "cartItem": {
    "sku": "61112633",
    "qty": 1,
    "quote_id": "62"
  }
}

Return: Cart item after adding to cart.

====================================================================

15. Estimated Shipping API:
POST /skin/rest/V1/carts/mine/estimate-shipping-methods HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: b6913da2-6c60-4b15-a1d6-da1fa21aa269
{  
	"address": {
	"region": "New York",
	"region_id": 43,
	"region_code": "NY",
	"country_id": "US",
	"street": [
		"123 Oak Ave"
	],
	"postcode": "10577",
	"city": "Purchase",
	"firstname": "Jane",
	"lastname": "Doe",
	"customer_id": 4,
	"email": "jdoe@example.com",
	"telephone": "(512) 555-1111",
	"same_as_billing": 1
  }
}

Return: Available shipping methods.

====================================================================

16. Get Payment Information API:
GET /skin/rest/V1/carts/mine/payment-information HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: 5508ce5d-c71a-453c-ad4f-67a5b38decfd

Return: List of payment methods.

====================================================================

17. Add Billing Info API:
POST /skin/rest/V1/carts/mine/billing-address HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: 69fb2e9e-5075-49b3-ab81-3e1f73eda619
{
	"address": {
		"city": "Ahmedabad",
		"company": "Rbj",
		"country_id": "US",
		"email": "sukumar@sharplogician.com",
		"firstname": "Sukumar",
		"lastname": "Gorai",
		"postcode": "30332",
		"region": "Georgia",
		"region_code": "GA",
		"region_id": 19,
		"street": [
		    "Street 1",
		    "Street 2"
		],
		"telephone": "123456"
	},
	"useForShipping": true
}

Return: Address ID.

====================================================================

18. Set Shipping and Billing information API:
POST /skin/rest/V1/carts/mine/shipping-information HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: 21c3259f-114a-4983-b66d-e2da1e38f0a2
{  
	"addressInformation": {
		"shipping_address": {
			"region": "New York",
			"region_id": 43,
			"region_code": "NY",
			"country_id": "US",
			"street": [
				"123 Oak Ave"
			],
			"postcode": "10577",
			"city": "Purchase",
			"firstname": "Sukumar",
			"lastname": "Gorai",
			"email": "sukumar@sharplogician.com",
			"telephone": "512-555-1111"
	  },
	  "billing_address": {
		"region": "New York",
		"region_id": 43,
		"region_code": "NY",
		"country_id": "US",
		"street": [
			"123 Oak Ave"
		],
		"postcode": "10577",
		"city": "Purchase",
		"firstname": "Sukumar",
		"lastname": "Gorai",
		"email": "sukumar@sharplogician.com",
		"telephone": "512-555-1111"
	  },
	  "shipping_carrier_code": "flatrate",
	  "shipping_method_code": "flatrate"
  	}
}

Return: Payment Method and other Cart details.

====================================================================

19. Create Order API:
POST /skin/rest/V1/carts/mine/payment-information HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer d9v54kfrzn4sfotulqco20xm8p0kshax (Customer Access Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: 2b4a1281-5e85-44d4-89ac-4793cb3ece89
{
	"paymentMethod": {
    	"method": "cashondelivery"
	},
	"billing_address": {
		"region": "New York",
		"region_id": 43,
		"region_code": "NY",
		"country_id": "US",
		"street": [
			"123 Oak Ave"
		],
		"postcode": "10577",
		"city": "Purchase",
		"firstname": "Sukumar",
		"lastname": "Gorai",
		"email": "sukumar@sharplogician.com",
		"telephone": "512-555-1111"
	}
}

Return: Order ID.

====================================================================

20. Get Messages API:
GET /skin/rest/V1/get-messages?date=2019-04-30 HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u
cache-control: no-cache
Postman-Token: 061779b4-2f5f-4b7b-8bcf-488869c86fee

Return: Messages with specified date.

====================================================================

21. Get Advertisement API:
GET /skin/rest/V1/get-advertisements?date=2019-04-30 HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u
cache-control: no-cache
Postman-Token: 7be70173-e31a-4865-9172-0c17893b1afa

Return: Advertisement with specified date.

====================================================================

22. Get Live Photos API:
GET /skin/rest/V1/live/get-photos HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u
cache-control: no-cache
Postman-Token: 8ce5e6a2-375b-400c-8cd7-48732fc04251

Return: List of live photos.

====================================================================

23. Wallpaper Listing with Sorting, Page, Limit API:
GET /skin/rest/V1/live/get-photos?order_by=description&order_direction=DESC&paginate=true&limit=1&offset=1 HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 90eb0851-fe1d-45db-abdc-e0de34d13a53

Return: List of live photos with requested sort order, sort direction, limit and page.

====================================================================

24. Search Live Photo API:
GET /skin/rest/V1/search-photos?query=Test HTTP/1.1
Host: 157.230.235.215
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
Content-Type: application/json
cache-control: no-cache
Postman-Token: b9b447ad-e781-4d4e-a3f6-12eecffaf81a

Return: List of live photos which matches search query.

====================================================================

25. Live Category Listing API:
GET /skin/rest/V1/live/get-categories? HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 16ff9ded-070e-43a4-b2e6-69f13e0f24e2

Return: List of live categories.

====================================================================

25. Update Live Photo Analytics (Views, Downloads) API:
GET /skin/rest/V1/live/update?id=photo_id&type=view/download&customer_id=id HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 16ff9ded-070e-43a4-b2e6-69f13e0f24e2

Return: true/false.

====================================================================

25. Update Wallpaper/PreDesigned Analytics (Views, Downloads) API:
GET /skin/rest/V1/live/update?id=wallpaper_id&type=view/download&customer_id=id HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u (Admin Token)
cache-control: no-cache
Postman-Token: 16ff9ded-070e-43a4-b2e6-69f13e0f24e2

Return: true/false.

====================================================================


[7:42 AM, 5/1/2020] Malik Adeel Ishfaq: 
[9:44 PM, 5/1/2020] Malik Adeel Ishfaq: Please find the API details of Social and Store Locator module:
====================================================================

Get Socials API:
GET /skin/rest/V1/get-socials HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u
cache-control: no-cache
Postman-Token: 8ce5e6a2-375b-400c-8cd7-48732fc04251

Return: List of socials.

====================================================================

Get Stores API:
GET /skin/rest/V1/get-stores HTTP/1.1
Host: 157.230.235.215
Content-Type: application/json
Authorization: Bearer b6xvn6198k6j1k4hb4r4z75s6tlsab9u
cache-control: no-cache
Postman-Token: 8ce5e6a2-375b-400c-8cd7-48732fc04251

Return: List of stores.

I have installed both the modules to skin website.
