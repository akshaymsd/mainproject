import 'package:flutter/material.dart';

import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';
import 'package:mainproject/widgets/custom_text_field.dart';
import 'package:http/http.dart' as http;

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {

  final FeedbackController = TextEditingController();

  bool  load = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.transparent,title: Text('Add Feedback'),),
      body: load ?  Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            CustomTextField(
              borderColor: Colors.grey,
              maxLines: 20,
              minLines: 10,
              hintText: 'Add review', controller: FeedbackController),
            const SizedBox(height: 30,),
        
            Row(
              children: [
                Expanded(
                  child: CustomButton(text: 'Add', onPressed: () async{
                   if(FeedbackController.text.isNotEmpty){


                     setState(() {
                      load = true;
                    }); 

                    await addFeedback(FeedbackController.text);

                    FeedbackController.clear();

                    setState(() {
                      load = false;
                    });

                   }else{


                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Feedback')));



                   }
                  
                  
                  }),
                ),
              ],
            )
        
        
          ],
        ),
      ),
    );
  }


   Future<void> addFeedback(String feedback) async {
    final url = Uri.parse('${ApiService.baseUrl}/api/user/add-feedback/${DbService.getLoginId()}');

    try {
      final response = await http.post(
        url,
        
        body: {
          'feedback' : feedback
        }
      );

      



      if (response.statusCode == 201) {
        // Feedback successfully added
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Feedback submitted successfully!'),
          duration: Duration(seconds: 2),
        ));
      } else {
        // Handle other status codes
        throw Exception('Failed to add feedback');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add feedback'),
        duration: Duration(seconds: 2),
      ));
    }
  }



}