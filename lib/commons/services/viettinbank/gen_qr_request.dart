/// Config for QR Viettinbank
class GenQrRequest {
  final String masterMerchant = '970489';
  final String merchantCode = '0402050829';
  final String merchantCC = '5045';
  final String merchantName = 'CTY DICH VU VA GP VINTECH';
  final String ccy = '704';
  final String countryCode = 'VN';
  final String terminalId = '121000085657';
  final String storeID = '121000085657';
  final String billNumber;
  final String amount;
  final String expDate;
  final String purpose;
  final String merchantCity = 'HANOI';

  GenQrRequest({
    required this.billNumber,
    required this.amount,
    required this.expDate,
    required this.purpose,
  });
}
