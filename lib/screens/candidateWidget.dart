import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';

class CandidateWidget extends StatelessWidget {
  final Candidate candidate;
  CandidateWidget({this.candidate});
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenOrg(election:election,user:user)));
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
