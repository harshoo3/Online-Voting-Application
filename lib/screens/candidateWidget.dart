import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/candidateManifesto.dart';

class CandidateWidget extends StatelessWidget {
  final User user;
  final Candidate candidate;
  final ElectionClass election;
  CandidateWidget({this.candidate,this.user,this.election});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SizedBox(
          height: 150,
          width: 300,
          child: FlatButton(
            onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateManifesto(candidate:candidate,user: user,election: election,)));
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    candidate.name
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 80, maxWidth: 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          candidate.partyLogoUrl,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
            ),
            color: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }
}
