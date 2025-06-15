//Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

class RankingCubit extends Cubit<Map<String, List<Map<String, String>>>> {
  RankingCubit()
    : super({
        'point': [
          {'stdName': 'Yihong',  'cID': '1', 'mark': '1500'},
          {'stdName': 'Recycle Monster', 'cID': '1', 'mark': '1300'},
          {'stdName': 'Mega Knight', 'cID': '1', 'mark': '1200'},
          {'stdName': 'Terralith', 'cID': '1', 'mark': '1200'},
          {'stdName': 'Cycloop never die', 'cID': '1', 'mark': '1123'},
          {'stdName': 'debate', 'cID': '1', 'mark': '1100'},
          {'stdName': 'lalat king', 'cID': '1', 'mark': '1002'},
          {'stdName': 'zei bi', 'cID': '1', 'mark': '323'},
          {'stdName': 'beimuyu', 'cID': '1', 'mark': '142'},
          {'stdName': 'Wen Hui', 'cID': '1', 'mark': '81'},
        ],
        'weight': [
          {'stdName': 'Yihong', 'cID': '1', 'mark': '90'},
          {'stdName': 'Recycle Monster', 'cID': '1', 'mark': '76'},
          {'stdName': 'Mega Knight', 'cID': '1', 'mark': '42'},
          {'stdName': 'Terralith', 'cID': '1', 'mark': '42'},
          {'stdName': 'Cycloop never die', 'cID': '1', 'mark': '41'},
          {'stdName': 'debate', 'cID': '1', 'mark': '39'},
          {'stdName': 'lalat king', 'cID': '1', 'mark': '35'},
          {'stdName': 'zei bi', 'cID': '1', 'mark': '32'},
          {'stdName': 'beimuyu', 'cID': '1', 'mark': '10'},
          {'stdName': 'Wen Hui', 'cID': '1', 'mark': '8'},
        ],
        'frequency': [
          {'stdName': 'Yihong', 'cID': '1', 'mark': '9'},
          {'stdName': 'Recycle Monster', 'cID': '1', 'mark': '7'},
          {'stdName': 'Mega Knight', 'cID': '1', 'mark': '4'},
          {'stdName': 'Terralith', 'cID': '1', 'mark': '4'},
          {'stdName': 'Cycloop never die', 'cID': '1', 'mark': '4'},
          {'stdName': 'debate', 'cID': '1', 'mark': '3'},
          {'stdName': 'lalat king', 'cID': '1', 'mark': '3'},
          {'stdName': 'zei bi', 'cID': '1', 'mark': '2'},
          {'stdName': 'beimuyu', 'cID': '1', 'mark': '1'},
          {'stdName': 'Wen Hui', 'cID': '1', 'mark': '1'},
        ],
      });
}
