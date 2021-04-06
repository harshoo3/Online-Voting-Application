class Candidate{
  List<dynamic>requestedCandidacy=[];
  List<dynamic>requestedCandidacyIndex=[];
  String partyName='';
  String partyLogoUrl='';
  String name='';
  String email='';
  bool approved;
  String campaignTagline='';
  List<String>questions=[];

  Candidate({this.partyLogoUrl,this.approved,this.campaignTagline,this.questions,this.name,this.email,this.partyName,this.requestedCandidacy,this.requestedCandidacyIndex});
}