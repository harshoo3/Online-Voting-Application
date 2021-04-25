import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/candidates/candidateManifesto.dart';

class CandidateWidget extends StatelessWidget {
  final User user;
  final Candidate candidate;
  final ElectionClass election;
  bool hasVoted;

  CandidateWidget({this.candidate,this.user,this.election,this.hasVoted});
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SizedBox(
          height: 100,
          width: 300,
          child: FlatButton(
            onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateManifesto( candidate:candidate,user: user,election: election,hasVoted: hasVoted)));
            },
            child: Center(
              child: Row(
                mainAxisAlignment: election.startDate.difference(DateTime.now()).inSeconds<0?MainAxisAlignment.start:MainAxisAlignment.spaceEvenly,
                children: [
                  election.isPartyModeAllowed?Container(
                    constraints: BoxConstraints(maxHeight: 70, maxWidth: 70),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          candidate.partyLogoUrl,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ):SizedBox(),
                  Text(
                    '   ${candidate.name} ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  election.startDate.difference(DateTime.now()).inSeconds<0?Text(
                    '  Votes: ${candidate.votes}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }
}
