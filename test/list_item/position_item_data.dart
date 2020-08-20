import 'package:flutter_deriv_api/api/contract/models/cancellation_info_model.dart';
import 'package:flutter_deriv_api/api/contract/operation/open_contract.dart';
import 'package:flutter_deriv_api/api/models/enums.dart';

final OpenContract openContractWithProfit = OpenContract(
  contractType: 'MULTUP',
  bidPrice: 13.1,
  profit: 25.5,
  currency: 'USD',
  multiplier: 30,
);

final OpenContract openContractWithLoss = openContractWithProfit.copyWith(
  profit: -10.25,
);

final OpenContract openContractWithCancellationInformation =
    openContractWithProfit.copyWith(
  cancellation: CancellationInfoModel(
    1.2,
    DateTime.now().add(const Duration(seconds: 1)),
  ),
);

final OpenContract closedContractWithCancellationInformation =
    openContractWithCancellationInformation.copyWith(
  status: ContractStatus.cancelled,
);
