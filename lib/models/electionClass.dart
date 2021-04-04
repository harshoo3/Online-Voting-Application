class ElectionClass {

  // List<String> candidates = [];
  // List<int> votes = [];
  DateTime startDate,endDate,setDate;
  bool isPartyModeAllowed;
  String post;
  String electionDescription;
  int maxCandidates;
  String index;
  int numOfWaitingCandidates;

  ElectionClass({this.index,this.startDate,this.endDate,this.setDate,this.isPartyModeAllowed,this.electionDescription,this.maxCandidates,this.post,this.numOfWaitingCandidates});
}
