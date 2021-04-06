import 'package:flutter/material.dart';
import 'package:online_voting/models/candidate.dart';
//
// class CandidateWidget extends StatefulWidget {
//   Candidate candidate;
//   CandidateWidget({this.candidate});
//   @override
//   _CandidateWidgetState createState() => _CandidateWidgetState(candidate: candidate);
// }
//
// class _CandidateWidgetState extends State<CandidateWidget> {
//   Candidate candidate;
//   _CandidateWidgetState({this.candidate});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: 150,
//       child: Center(
//         child: FlatButton(
//           child: Text(
//               candidate.name
//           ),
//           onPressed: (){
//
//             // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
//           },
//           color: Colors.yellow,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18.0),
//
//           ),
//         ),
//       ),
//     );
//   }
// }
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.network(
                      candidate.partyLogoUrl,
                      // fit: BoxFit.cover,
                      height: 90,
                      width: 150,
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
