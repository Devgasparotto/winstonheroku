Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #Root Page
  root 'welcome#index'

  get "/testPDF/", to: "welcome#testPDF"
  get "/testEmail/", to: "welcome#testEmail"
  get "/testRoute/", to: "welcome#testRoute"

  get "/CreateSamplePDF/", to:"pdf#CreateSamplePDF"
  get "/CreateAndEmailSamplePDF/", to:"pdf#CreateAndEmailSamplePDF"

  get "/TicketForm", to: "ticket#index"
  

  #Registration
  post "/registerChatfuelUser/", to: "chatfuel_registration#RegisterChatfuelUser"
  get "/registerFacebookUser/", to: "facebook_registration#RegisterFacebookUserAuthenticate"
  post "/registerFacebookUser/", to: "facebook_registration#AttemptToRegisterFacebookUser"

  #Token
  get "/generateToken", to: "user_information#GenerateToken"

  #Ticket
  post "/createNewTicket/", to: "ticket#CreateTicket"
  get "/updateTicketAttribute/", to: "ticket#UpdateTicketAttributeByFacebookId"
  #get "/updateBasicTicketInfo", to: "ticket#UpdateTicketOffenceNumberOffenceDateICONCode"
  get "/updateTicketName", to: "ticket#UpdateTicketName"
  post "/updateTicketMailingAddress", to: "ticket#UpdateTicketAddressByFacebookId"
  get "/updateCourtDate/", to: "ticket#UpdateCourtDate"
  get "/updateOfficer/", to: "ticket#UpdateOfficer"
  post "/updateOffenceNumber/", to: "ticket#UpdateTicketOffenceNumber"
  post "/updateOffenceDate/", to: "ticket#UpdateTicketOffenceDate"
  post "/updateTicketCourthouse/", to: "ticket#UpdateTicketCourthouse"
  post "/updateTicketCharge/", to: "ticket#UpdateTicketCharge"
  post "/updateDisclosureRequestName", to: "ticket#UpdateDisclosureRequestName"
  post "/updateIsOffenceDateCorrect", to: "ticket#UpdateIsOffenceDateCorrect"
  post "/updateIsDefendantNameCorrect", to: "ticket#UpdateIsDefendantNameCorrect"
  post "/updateIsLanguageInterpreterRequired", to: "ticket#UpdateIsLanguageInterpreterRequired"
  
  get "/getCourthouseGoogleMapURL", to: "address#GetCourthouseLocationForCurrentTicket"

  #Trial
  get "/createTrial/", to: "trial#CreateTrial"
  get "/updateTrialCourthouse/", to: "trial#UpdateTrialCourthouse"
  get "/updateTrialCourtroom/", to: "trial#UpdateTrialCourtroom"
  get "/updateTrialCourtDate/", to: "trial#UpdateTrialCourtDate"

  #Intention to Appear
  get "/getNOIWebview", to: "poa_form#GenerateNOIWebviewButton"
  get "/noticeOfIntentionForm", to: "poa_form#notice_of_intention_form"
  post "/sendFormattedPOAFormToChat", to: "poa_form#SendFormattedPOAFormToChat"
  post "/savePOAInformation", to: "poa_form#SavePOAInformation"
  get "/NoticeOfIntentionToAppearForm", to: "poa_form#NoticeOfIntentionToAppearForm"
  post "/deleteNOIForm", to: "poa_form#DeleteNOIForm"

  get "/testEmail", to: "poa_form#EmailTest"

  # Disclosure Request
  get "/getDisclosureWebview", to: "disclosure_request_form#GenerateDisclosureWebviewButton"
  get "/requestForDisclosureForm", to: "disclosure_request_form#index"  

  get "/getDisclosureForm", to: "disclosure_form#index"
  get "/disclosureForm", to: "disclosure_form#GetRenderedDisclosureForm"
  
  
  post "/sendFormattedDisclosureRequestFormToChat", to: "disclosure_request_form#SendDisclosureRequestInChat"
  get "/DisclosureRequestForm", to: "disclosure_request_form#DisclosureRequestForm"
  get "/DisclosureRequestLetter", to: "disclosure_request_form#DisclosureRequestLetter"

  post "/saveDisclosureRequestInformation", to: "disclosure_request_form#SaveDisclosureRequestInformation"

  get "/generateDisclosureRequestForm", to: "disclosure_request_form#index_email_only"
 # post "/formatDisclosureRequestPDF", to: "disclosure_request_form#FormatDisclosureRequestPDF" --Not required

  #Timer 
  get "/sendMessage/", to: "facebook_registration#TestSendingMessage"

  post "/createTrialRequestReminder/", to: "timer#CreateTrialRequestReminder"
  post "/executeTrialRequestTimers/", to: "timer#ExecuteTrialRequestTimers"
  post "/deleteTrialRequestTimers/", to: "timer#DeleteTrialRequestTimers"
 
  post "/createTrialDateReminder/", to: "timer#CreateTrialDateReminder"
  post "/executeTrialDateTimers/", to: "timer#ExecuteTrialDateTimers"
  post "/deleteTrialDateTimers/", to: "timer#DeleteTrialDateTimers"
 
  post "/createDisclosureRequestReminder/", to: "timer#CreateDisclosureRequestReminder"
  post "/executeDisclosureRequestTimers/", to: "timer#ExecuteDisclosureRequestTimers"
  post "/deleteDisclosureRequestTimers/", to: "timer#DeleteDisclosureRequestTimers"
 
  post "/createPrepareForTrialReminder/", to: "timer#CreatePrepareForTrialReminder"
  post "/executePrepareForTrialTimers/", to: "timer#ExecutePrepareForTrialTimers"
  post "/deletePrepareForTrialTimers/", to: "timer#DeletePrepareForTrialTimers"
 
  post "/createDisclosureFollowUpReminder/", to: "timer#CreateDisclosureFollowUpDateReminder"
  post "/executeDisclosureFollowUpTimers/", to: "timer#ExecuteDisclosureFollowUpDateTimers"
  post "/deleteDisclosureFollowUpTimers/", to: "timer#DeleteDisclosureFollowUpDateTimers"

  #Date and Time Entry
  get "/enterDateTime", to: "datetime_input#index"  
  get "/getDateTimeWebview", to: "datetime_input#GenerateDateTimeInputWebviewButton"
  post "/saveTimeStamp", to: "datetime_input#saveDateTime"

  post "/updateNoticeOfIntentionSubmissionDate", to: "datetime_input#UpdateNoticeOfIntentionSubmissionDate"
  post "/updateDisclosureRequestSubmissionDate", to: "datetime_input#UpdateDisclosureRequestSubmissionDate"

  #Courthouse
  post "/getTrialRequestSubmissionLocation", to: "ticket#TrialRequestSubmissionLocation"

  #Recall
  post "/setRecallBlock", to: "recall#SetRecallBlock"
  post "/getRecallBlock", to: "recall#GetRecallBlockJSON"

  #Input Validation
  get "/isDateTimeInPast", to: "input_validator#IsDateTimeInPast"
  get "/isDateInPast", to: "input_validator#IsDateInPast"
  get "/isDateTimeFormatCorrect", to: "input_validator#IsDateTimeFormatCorrect"
  get "/isDateFormatCorrect", to: "input_validator#IsDateFormatCorrect"

  # Messenger webhook component
  get "/webhook", to: "messenger_component#webhook"
  get "/msg_test", to: "messenger_component#index"


  #Test
  get "/getTest", to: "payment#TestFBName"

  #Payment
  post "/applyPromoCode", to: "payment#ApplyPromoCode"
  post "/submitNOIDeliveryRequest", to: "payment#SubmitNOIDeliveryRequest"
  get "/getPaymentWebview", to: "payment#GeneratePaymentWebviewButton"
  get "/noiPromoCodeEntry", to: "payment#noi_promo_code_entry"

  #Court Dates
  get "/getCourtDate", to: "court_date#GetCourtDate"
  get "/getCourtDateByUser", to: "court_date#getCourtDateByUserId"
  get "/getCourtIndex", to: "court_date#index"

  #Charge Types
  post "/updateChargeType", to: "charge#saveChargeTypeForOffence"


  #Image
  get "/getImageUrl", to: "disclosure_request_form#GetImageUrl"
  get "/ImageAttr", to: "disclosure_request_form#SendIconAndOffenceInChat"
  

  get "/SeeNextId"  , to: "disclosure_request_form#SeeNextId"

end
