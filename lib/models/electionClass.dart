class ElectionClass {

  // List<String> candidates = [];
  // List<int> votes = [];
  DateTime startDate,endDate,setDate;
  bool isPartyModeAllowed;
  String post;
  String electionDescription;
  int maxCandidates;
  String index;
  int numOfCandidates;
  int votes;
  int numOfApprovedCandidates;
  ElectionClass({this.index,this.startDate,this.votes,this.endDate,this.numOfApprovedCandidates,this.setDate,this.isPartyModeAllowed,this.electionDescription,this.maxCandidates,this.post,this.numOfCandidates});
}
