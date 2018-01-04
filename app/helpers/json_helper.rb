module JsonHelper

	def CreateBlockButton(buttonText, referenceBlock)
		button={
			"type": "show_block",
			"block_name": "[#{referenceBlock}]",
			"title": buttonText
		}
		return button
	end

	def CreateButton(buttonText)
 		button={
 			"type": "web_url",
 			"url": "www.google.ca",
 			"title": "#{buttonText}"
 		}
 		return button
 	end	
	def CreateURLButton(buttonText, url)
		button={
			"type": "web_url",
			"url": url,
			"title": buttonText
		}
		return button
	end

	def CreateWebviewButton(url, buttonText, fallbackURL)
		button={
			"type": "web_url",
			"url": url,
			"title": buttonText,
			"webview_height_ratio": "full",
			"messenger_extensions": true, #could be a problem here
			"fallback_url": fallbackURL
		}
		return button
	end

	def CreateButtonPayload(messageText, buttons)
		payload={
			"template_type":"button",
			"text":messageText,
			"buttons":buttons
		}
		return payload
	end

	def CreatePayloadAttachment(payload)
		attachment={
			"type":"template",
			"payload":payload
		}
		return attachment
	end

	def CreateMessageWithAttachment(attachment)
		message={
			"attachment":attachment
		}
		return message
	end

	def CreateJSONWithText(text)
 		return {"text":text}
 	end

	def CreateJSONWithSingleBlockButton(messageText, buttonText, recallButtonName)
		buttons = Array.new
		buttons.push(CreateBlockButton(buttonText, recallButtonName))
		payload = CreateButtonPayload(messageText, buttons)
		attachment = CreatePayloadAttachment(payload)
		messageArray = Array.new
		messageArray.push(CreateMessageWithAttachment(attachment))

		messages={
			"messages":messageArray
		}

		return messages
	end

	def CreateJSONWithBlockButtons(messageText, buttonTextBlockNameHash)
		buttons = Array.new
		buttonTextBlockNameHash.each do |buttonText, blockName|
			buttons.push(CreateBlockButton(buttonText, blockName))
		end
		
		payload = CreateButtonPayload(messageText, buttons)
		attachment = CreatePayloadAttachment(payload)
		messageArray = Array.new
		messageArray.push(CreateMessageWithAttachment(attachment))

		messages={
			"messages":messageArray
		}

		return messages
	end

	def CreateJSONWithButtons(messageText, buttonArray)
		buttons = Array.new
		buttonArray.each do |buttonText|
			buttons.push(CreateButton(buttonText))
		end
		
		payload = CreateButtonPayload(messageText, buttons)
		attachment = CreatePayloadAttachment(payload)
		messageArray = Array.new
		messageArray.push(CreateMessageWithAttachment(attachment))

		messages={
			"messages":messageArray
		}

		return messages
	end	

	def CreateSingleURLJSON(url, title, buttonText)
		buttons = []
		buttons.push(CreateURLButton(buttonText, url))

		element = {
			"title": title,
			"buttons": buttons
		}
		elements = []
		elements.push(element)
		
		payload = {
			"template_type": "generic",
			"elements": elements
		}

		attachment = {
			"type": "template",
			"payload": payload
		}

		messageArray=[]
		messageArray.push(CreateMessageWithAttachment(attachment))

		messages={
			"messages":messageArray
		}

		return messages.to_json
	end

	def CreateJSONWithBlockButtons(messageText, buttonTextBlockNameHash)
 		buttons = Array.new
 		buttonTextBlockNameHash.each do |buttonText, blockName|
 			buttons.push(CreateBlockButton(buttonText, blockName))
 		end
 		
 		payload = CreateButtonPayload(messageText, buttons)
 		attachment = CreatePayloadAttachment(payload)
 		messageArray = Array.new
 		messageArray.push(CreateMessageWithAttachment(attachment))
 
 		messages={
 			"messages":messageArray
 		}
 
 		return messages
 	end
 
 	def CreateJSONWithButtons(messageText, buttonArray)
 		buttons = Array.new
 		buttonArray.each do |buttonText|
 			buttons.push(CreateButton(buttonText))
 		end
 		
 		payload = CreateButtonPayload(messageText, buttons)
 		attachment = CreatePayloadAttachment(payload)
 		messageArray = Array.new
 		messageArray.push(CreateMessageWithAttachment(attachment))
 
 		messages={
 			"messages":messageArray
 		}
 
 		return messages
 	end

	def CreateWebviewURLJSON(url, subtitle, buttonText, fallbackURL)
		buttons = []
		buttons.push(CreateWebviewButton(url, buttonText, fallbackURL))
		
		payload = CreateButtonPayload(subtitle, buttons)

		attachment = {
			"type": "template",
			"payload": payload
		}

		messageArray=[]
		messageArray.push(CreateMessageWithAttachment(attachment))

		messages={
			"messages":messageArray
		}

		return messages.to_json
	end

	def CreateSingleAttributeJSON(attributeName, attributeValue)
		attributes = {
			"#{attributeName}": attributeValue
		}
		
		messageArray = []

		setAttributeJSON = {
			"set_attributes": attributes,
			"messages": messageArray
		}

		return setAttributeJSON.to_json
	end
	
	def CreateDoubleAttributeJSON(attributeName1, attributeValue1, attributeName2, attributeValue2)
		attributes = {
			"#{attributeName1}": attributeValue1,
			"#{attributeName2}": attributeValue2
		}
		
		messageArray = []

		setAttributeJSON = {
			"set_attributes": attributes,
			"messages": messageArray
		}

		return setAttributeJSON.to_json
	end

end
