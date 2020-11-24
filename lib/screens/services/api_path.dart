class APIPath {
  static String addCook(String uid) {
    return "customer/$uid";
  }

  static String addItem(String uid) {
    return "cooks/$uid";
  }

  static String getUserName(String uid) {
    return "/customer/$uid/";
  }

  static String getOrdersReceived(String uid) {
    return "/cooks/$uid/ordersReceived";
  }

  static String getItems(String uid) {
    return "/cooks/$uid/";
  }

  // static String job(String uid, String jobId) {
  //   return '/users/$uid/jobs/$jobId';
  // }
}
