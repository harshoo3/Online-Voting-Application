import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';

class CustomMethods{

  double calculateElectionProgress(ElectionClass election){
    if(election!=null){
      num bigdiff = election.endDate.difference(election.startDate).inSeconds;
      num smalldiff = DateTime.now().difference(election.startDate).inSeconds;
      double ans = smalldiff/bigdiff;
      if(ans>1){
        return 1;
      }else if(ans<0){
        return 0;
      }else{
        return ans;
      }
    }
  }
  double calculateVotePercentage({int totalVoters,int votes}){
    return totalVoters==0?0:((votes*100)/totalVoters);
  }
}
