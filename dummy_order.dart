class OrderData {
  OrderData({required this.id, required this.company, required this.address});
  final String id;
  final String company;
  final String address;
}

List<OrderData> allorder = [
  OrderData(
    id: '1234',
    company: 'The Spring',
    address: 'Jalan Simpang Tiga',
  ),
  OrderData(
    id: '5678',
    company: 'Vivacity',
    address: 'Jalan Alwi',
  ),
  OrderData(
    id: '9101',
    company: 'TeaPack',
    address: 'Saradise',
  ),
  OrderData(
    id: '1112',
    company: 'Everise',
    address: 'Jalan Song',
  ),
];