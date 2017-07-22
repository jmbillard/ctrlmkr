struct gernericSliderWithSpinnerAttributes_source (

	-- contains the strings for the custom attributes rollout...
	fn buildUi uiNumber rollName colorArray nameArray minRangeArray maxRangeArray = (	

		-- defines all the color values, names and ranges in locoal variables...
		uiVariables = ""
		params = ""
		colorui = ""
		for i in 1 to uiNumber as integer do (
			iS = i as string
			append uiVariables (\
				"local color" + iS + " = " + colorArray[i] as string + "," +\
				"min" + iS + " = " + minRangeArray[i] as string + "," +\
				"max" + iS + " = " + maxRangeArray[i] as string + "," +\
				"sldname" + iS + " = \"" + nameArray[i] + "\" + \": \"\n" \
				)

			-- sets the parameter block (links the spinner and slider parameters)...
			append params ("'" + rollName + "_" + nameArray[i] + "' type:#float ui:(spn" + iS + ",sld" + iS + ")\n")

			-- creates the ui (spinner, slider and color tag)...
			rangeVal = "[min" + iS + ",max" + iS + ",min" + iS + "]"
			append colorui (\
				"group \" " + nameArray[i] + ": \" (\n" +\
				"imgTag img" + iS + " bitmap:(bitmap 2 48 color:color" + iS + ") align:#left offset:[0,4] across:2\n" +\
				"spinner spn" + iS + " \"\" range:" + rangeVal + " type:#float fieldWidth:128 scale:0.01 align:#center offset:[-44,8]\n" +\
				"slider sld" + iS + " \"\" width:150 range:" + rangeVal + " ticks:6 align:#center offset:[8,-32]\n)\n"\
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