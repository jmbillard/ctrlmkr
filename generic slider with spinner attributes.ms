struct gernericSliderWithSpinnerAttributes_source (


	fn setPropUi uiNumber = (		

		rollStart = "rollout setPropUi \"ui properties\" width:220\n(\n"

		mainGrp = \
			"group \"\" (\n"+\
			"label lab_roll \"rollout name:\" align:#left offset:[0,-8]\n"+\
			"editText roll_name \"\" text:\"my rollout\" width:200 height:16 align:#right offset:[0,0]\n"+\
			"button ceate_btn \"create custom attributes >\" width:198 height:30 offset:[-2,0]\n)\n"+\
			"group \"\" (\n"
		
		tagcolor = random (color 0 0 0) (color 255 255 255)
		offset = "[-7,-6]"

		colorparamGrp = ""
		for i in 1 to uiNumber as integer do (
			iS = i as string
			lastLine = "label spacer" + iS + " \"______________________________\" align:#center offset:[0,-2] enabled:false\n"
			if i == uiNumber do lastLine = "label spacer" + iS + " \"\" align:#center offset:[0,-12] enabled:false\n"
			append colorparamGrp (\
				"colorpicker tag_color" + iS + " \"\" color:" + tagcolor as string + " width:65 height:20 align:#left offset:" + offset +"\n"+\
				"label lab_spn" + iS + " \"tag color and name:\" align:#left offset:[65,-22]\n"+\
				"editText sld_name" + iS + " \"\" text:\"my slider " + iS + "\" width:200 height:16 align:#right offset:[0,0]\n"+\
				"spinner ui_spn_min" + iS + " \"\" width:60 range:[-9999999,9999999,-100] type:#float align:#left offset:[-4,0]\n"+\
				"spinner ui_spn_max" + iS + " \"\" width:60 range:[-9999999,9999999,100] type:#float align:#right offset:[0,-21]\n"+\
				"label lab_range" + iS + " \"< ranges >\" align:#center offset:[0,-21]\n"+\
				lastLine\
				)
			tagcolor = tagcolor * 0.5
			offset = "[-7,4]"
			)
		/*
		attributescolorArray = ctrlmkr_Utilities.createArray (uiNumber as integer) ("color") (colorArray) ("tag_color") ("color")
		attributesnameArray = ctrlmkr_Utilities.createArray (uiNumber as integer) ("name") (nameArray) ("sld_name") ("text")
		attributesminArray = ctrlmkr_Utilities.createArray (uiNumber as integer) ("min") (minArray) ("ui_spn_min") ("value")
		attributesmaxArray = ctrlmkr_Utilities.createArray (uiNumber as integer) ("max") (maxArray) ("ui_spn_max") ("value")

		events = \
			"on ceate_btn pressed do\n	(\n if selection.count != 1 then messagebox \"select one control object...\"\n else (\n"+\
			"" + attributescolorArray + "\n" + attributesnameArray + "\n" + attributesminArray + "\n" + attributesmaxArray + "\n"+\
			"gernericSliderWithSpinnerAttributes_source.buildUi (" + uiNumber as string + ") (roll_name.text) (color) (name) (min) (max)\n"+\
			")\n)\n)\n"
			*/
		rollEnd = "createDialog setPropUi"

		parameterscolorUi = rollStart + mainGrp + colorparamGrp + "))" + rollEnd

		execute parameterscolorUi
		),

	-- contains the strings for the custom attributes rollout...
	fn buildUi uiNumber rollName colorArray nameArray minRangeArray maxRangeArray = (	

		-- defines all the color values, names and ranges in locoal variables...
		uiVariables = ""
		params = ""
		colorui = ""
		for i in 1 to uiNumber as integer do (
			iS = i as string
			append uiVariables (\
				"local color" + iS + " = " + colorArray[i] as string + ","+\
				"min" + iS + " = " + minRangeArray[i] as string + ","+\
				"max" + iS + " = " + maxRangeArray[i] as string + ","+\
				"sldname" + iS + " = \"" + nameArray[i] + "\" + \": \"\n" \
				)

			-- sets the parameter block (links the spinner and slider parameters)...
			append params ("'" + rollName + "_" + nameArray[i] + "' type:#float ui:(spn" + iS + ",sld" + iS + ")\n")

			-- creates the ui (spinner, slider and color tag)...
			rangeVal = "[min" + iS + ",max" + iS + ",min" + iS + "]"
			append colorui (\
				"group \" " + nameArray[i] + ": \" (\n"+\
				"imgTag img" + iS + " bitmap:(bitmap 2 48 color:color" + iS + ") align:#left\n"+\
				"spinner spn" + iS + " \"\" width:136 range:" + rangeVal + " type:#float scale:0.01 align:#center offset:[2,-50]\n"+\
				"slider sld" + iS + " \"\" width:149 range:" + rangeVal + " ticks:6 align:#center offset:[8,-2]\n)\n"\
				)
			)

		-- starts the custom attribute definition...
		attributeStart = "cA = Attributes '" + rollName + "' (\nparameters '" + rollName + "' rollout:'" + rollName + "Ui' (\n"

		-- starts the rollout definition...
		rollStart = ")\nrollout '" + rollName + "Ui' \"" + rollName + "\" (\n" + uiVariables + "\n"

		-- ends and adds the custom attribute definition...
		attributeEnd = ")\n)\ncustAttributes.add $.modifiers[1] cA\nfree ca"

		-- concatenates all the strings...
		uiElements = attributeStart + params + rollStart + colorui + attributeEnd
		execute uiElements
		)
	)

gernericSliderWithSpinnerAttributes_source = gernericSliderWithSpinnerAttributes_source()

gernericSliderWithSpinnerAttributes_source.setPropUi 5