import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/api/responses/payment_methods/payment_method_response.dart';
import 'package:lakasir/api/responses/transactions/selling_detail.dart';

class TransactionHistoryResponse {
  int id;
  int? memberId;
  String? date;
  String? code;
  double? payedMoney;
  double? moneyChange;
  double? totalPrice;
  bool friendPrice;
  int paymentMethodId;
  double? tax;
  int? totalQuantity;
  MemberResponse? member;
  PaymentMethodRespone? paymentMethod;
  List<SellingDetail>? sellingDetails;
  String? createdAt;
  String? updatedAt;
  int? customerNumber;

  TransactionHistoryResponse({
    required this.id,
    this.memberId,
    this.date,
    this.code,
    this.payedMoney,
    this.moneyChange,
    this.totalPrice,
    required this.friendPrice,
    required this.paymentMethodId,
    this.tax,
    this.totalQuantity,
    this.member,
    this.paymentMethod,
    this.sellingDetails,
    this.createdAt,
    this.updatedAt,
    this.customerNumber,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      id: json['id'],
      memberId: json['member_id'],
      date: json['date'],
      code: json['code'],
      payedMoney: double.parse(json['payed_money'].toString()),
      moneyChange: double.parse(json['money_changes'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      friendPrice: bool.fromEnvironment(json['friend_price'].toString()),
      paymentMethodId: json['payment_method_id'],
      tax: double.parse(json['tax'].toString()),
      totalQuantity: json['total_qty'],
      member: json['member'] != null
          ? MemberResponse.fromJson(json['member'])
          : null,
      paymentMethod: json['payment_method'] != null
          ? PaymentMethodRespone.fromJson(json['payment_method'])
          : null,
      sellingDetails: json['selling_details'] != null
          ? (json['selling_details'] as List)
              .map((e) => SellingDetail.fromJson(e))
              .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      customerNumber: json['customer_number'],
    );
  }
}
