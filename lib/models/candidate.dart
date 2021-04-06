class Candidate{
  List<dynamic>requestedCandidacy=[];
  List<dynamic>requestedCandidacyIndex=[];
  String partyName='';
  String partyLogoUrl='';
  String name='';
  String email='';
  bool approved;
  bool denied;
  String campaignTagline='';
  List<dynamic>questions=[];

  Candidate({this.partyLogoUrl,this.denied,this.approved,this.campaignTagline,this.questions,this.name,this.email,this.partyName,this.requestedCandidacy,this.requestedCandidacyIndex});
}