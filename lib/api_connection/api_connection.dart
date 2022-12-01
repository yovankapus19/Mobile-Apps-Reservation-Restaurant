class API {
  static const hostConnect = "http://192.168.1.27/foodies_api";
  static const hostConnectUser = "$hostConnect/user/";

  // signUp user
  static const signUp = "$hostConnect/user/signup.php";
  // Validate Email
  static const validateEmail = "$hostConnect/user/validate_email.php";

  static const signUpNew = "http://192.168.1.27/foodies_api/user/signup.php";
  static const checkEmail =
      "http://192.168.1.27/foodies_api/user/validate_email.php";
  static const login = "http://192.168.1.27/foodies_api/user/login.php";

  // Login Admin
  static const adminlogin = "http://192.168.1.27/foodies_api/admin/login.php";

  // Food Popular
  static const getTrendingMostPopularClothes =
      "http://192.168.1.27/foodies_api/food/trending.php";
  // All Food
  static const getAllFood = "http://192.168.1.27/foodies_api/food/all.php";
  // Cart
  static const addToCart = "http://192.168.1.27/foodies_api/cart/add.php";
  static const addToCartTemp =
      "http://192.168.1.27/foodies_api/cart/cart_temp.php";

  static const getCartList = "http://192.168.1.27/foodies_api/cart/read.php";

  static const deleteSelectedItemsFromCartList =
      "http://192.168.1.27/foodies_api/cart/delete.php";

  static const deleteSelectedItemsFromCartListTemp =
      "http://192.168.1.27/foodies_api/cart/deleteCartTemp.php";

// Restaurant
  static const getAllRestaurant =
      "http://192.168.1.27/foodies_api/restaurant/getAll.php";

  static const getRestauranFood =
      "http://192.168.1.27/foodies_api/restaurant/readFood.php";

  static const getRestaurantAll =
      "http://192.168.1.27/foodies_api/restaurant/getAllRestaurant.php";

  static const imagesRes =
      "http://192.168.1.27/foodies_api/restaurant/imagesRes.php";

  // Summary
  static const addSummary = "http://192.168.1.27/foodies_api/cart/summary.php";
  static const getSummary =
      "http://192.168.1.27/foodies_api/cart/getSummary.php";

  // Transaksi
  static const addTransaksi =
      "http://192.168.1.27/foodies_api/transaksi/transaksi.php";
  static const getTransaksi =
      "http://192.168.1.27/foodies_api/transaksi/getTransaksi.php";

  // Update Saldo
  static const updateSaldo =
      "http://192.168.1.27/foodies_api/user/updateSaldo.php";

// Filter Kategori
  static const kategoriFilter =
      "http://192.168.1.27/foodies_api/restaurant/categoryFilter.php";

// search
  static const searchItems =
      "http://192.168.1.27/foodies_api/restaurant/search.php";

  // Saldo
  static const saldo = "http://192.168.1.27/foodies_api/user/saldo.php";
}
