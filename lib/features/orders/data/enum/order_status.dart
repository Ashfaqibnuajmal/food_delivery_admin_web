enum OrderStatus {
  making("Making"),
  packing("Packing"),
  outForDelivery("Out for Delivery"),
  delivered("Delivered");

  final String label;

  const OrderStatus(this.label);
}
