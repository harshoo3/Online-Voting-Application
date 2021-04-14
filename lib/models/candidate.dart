class Candidate{
  List<dynamic>requestedCandidacy=[];
  List<dynamic>requestedCandidacyIndex=[];
  String partyName='';
  String partyLogoUrl='';
  String name='';
  String email='';
  bool approved;
  bool denied;
  dynamic index;
  num votes;
  String campaignTagline='';
  List<dynamic>questions=[];

  Candidate({this.partyLogoUrl,this.votes,this.denied,this.approved,this.campaignTagline,this.questions,this.name,this.email,this.partyName,this.index,this.requestedCandidacy,this.requestedCandidacyIndex});
}