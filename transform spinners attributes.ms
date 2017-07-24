struct transformSpinnersAttributes_source (

	-- contains the item label for the main ui...
	attributeLabel = "transform spinners xyz",

	-- contains the strings to setup the custom attributes...
	fn setUpUiPrp iS = (

		range1 = "[-99999999999,99999999999,-9999]"
		range2 = "[-99999999999,99999999999,9999]"
		setPropGrp = (\
			"group \" transform spinners xyz: \" (\n"+\
			"radiobuttons rdo_trm" + iS + " \"\" labels:#(\"pos\",\"rot\",\"scale\") align:#left columns:1 offset:[0,2]\n" +\
			"imgTag img_" + iS + "X bitmap:(bitmap 2 12 color:red) align:#center offset:[-34,-52]\n"+\
			"spinner ui_spnX_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnX_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n"+\
			"imgTag img_" + iS + "Y bitmap:(bitmap 2 12 color:green) align:#center offset:[-34,0]\n"+\
			"spinner ui_spnY_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnY_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n"+\
			"imgTag img_" + iS + "Z bitmap:(bitmap 2 12 color:blue) align:#center offset:[-34,0]\n"+\
			"spinner ui_spnZ_min" + iS + " \"\"  width:60 range:" + range1 + " type:#float align:#center offset:[0,-19]\n"+\
			"spinner ui_spnZ_max" + iS + " \"\" width:60 range:" + range2 + " type:#float align:#right offset:[0,-21]\n)\n"
			)

		return setPropGrp
		),

	-- contains the strings for the custom attributes rollout...
	fn caParamUi rollName posCheck rotCheck scaleCheck posXmin posXmax posYmin posYmax posZmin posZmax rotXmin rotXmax rotYmin rotYmax rotZmin rotZmax scaleXmin scaleXmax scaleYmin scaleYmax scaleZmin scaleZmax = (

		-- creates the ui (spinner and color tag)...
		fn grupBlock tProp Range1 Range2 Range3 = (
			spnCommonParams = "fieldwidth:128 align:#center scale:0.01"
			"group \" " + tProp + ": \" (\n"+\
			"imgTag img_" + tProp + "X bitmap:(bitmap 2 12 color:red) align:#left across:2 offset:[0,2]\n"+\
			"spinner spn_" + tProp + "X \"\" range:" + Range1 + " " + spnCommonParams + " offset:[-44,0]\n"+\
			"imgTag img_" + tProp + "Y bitmap:(bitmap 2 12 color:green) align:#left across:2 offset:[0,-2]\n"+\
			"spinner spn_" + tProp + "Y \"\" range:" + Range2 + " " + spnCommonParams + " offset:[-44,-4]\n"+\
			"imgTag img_" + tProp + "Z bitmap:(bitmap 2 12 color:blue) align:#left across:2 offset:[0,-2]\n"+\
			"spinner spn_" + tProp + "Z \"\" range:" + Range3 + " " + spnCommonParams + " offset:[-44,-4])\n"
			)

		-- parameter block...
		fn parametersBlock tProp rollName defValue = (
			defValueS = defValue as string
			"'" + rollName + "_" + tProp + "X' type:#float default:" + defValueS + " ui:(spn_" + tProp + "X)\n"+\
			"'" + rollName + "_" + tProp + "Y' type:#float default:" + defValueS + " ui:(spn_" + tProp + "Y)\n"+\
			"'" + rollName + "_" + tProp + "Z' type:#float default:" + defValueS + " ui:(spn_" + tProp + "Z)\n"
			)

		-- sets the possible spinner range...
		fn setRanges minValue maxValue defValue = (
			"[" + minValue as string + "," + maxValue as string + "," + defValue as string + "]"
			)

		-- starts the custom attribute definition...
		attributeStart = \
		"cA = Attributes '" + rollName + "'\n(\nparameters '" + rollName + "' rollout:'" + rollName + "Ui'\n(\n"

		-- sets the parameter block... 
		paramsPos = parametersBlock "position" "roll name" 0
		paramsRot = parametersBlock "rotation" "roll name" 0
		paramsScale = parametersBlock "scale" "roll name" 1

		-- starts the rollout definition...
		rollStart = ")\nrollout '" + rollName + "Ui' \"" + rollName + "\" (\n"

		-- creates the position ui...
		posXRange = setRanges posXmin posXmax 0
		posYRange = setRanges posYmin posYmax 0
		posZRange = setRanges posZmin posZmax 0
		posGrp = grupBlock "position" posXRange posYRange posZRange

		-- creates the rotation ui...
		rotXRange = setRanges rotXmin rotXmax 0
		rotYRange = setRanges rotYmin rotYmax 0
		rotZRange = setRanges rotZmin rotZmax 0
		rotGrp = grupBlock "rotation" rotXRange rotYRange rotZRange

		-- creates the scale ui (with a uniform scale toggle)...
		scaleXRange = setRanges scaleXmin scaleXmax 1
		scaleYRange = setRanges scaleYmin scaleYmax 1
		scaleZRange = setRanges scaleZmin scaleZmax 1
		scaleGrp = (\
		"label lab_uniformScale \"uniform scale\" align:#left across:2\n"+\
		"checkBox ckb_uniformScale \"\" align:#right across:1 checked:false offset:[10,0]\n"+\
		grupBlock "scale" scaleXRange scaleYRange scaleZRange+\
		"on ckb_uniformScale changed state do (\n"+\
		"if ckb_uniformScale.checked == true then (\n"+\
		"spn_ScaleY.enabled = false; spn_ScaleZ.enabled = false	\n"+\
		"spn_ScaleY.value = spn_ScaleX.value\n"+\
		"spn_ScaleZ.value = spn_ScaleX.value\n)\n"+\
		"else (spn_ScaleY.enabled = true; spn_ScaleZ.enabled = true)\n)\n"+\
		"on spn_ScaleX changed val do (\n"+\
		"if ckb_uniformScale.checked == true do (\n"+\
		"spn_ScaleY.value = spn_ScaleX.value\n"+\
		"spn_ScaleZ.value = spn_ScaleX.value\n)\n)\n"
		)

		-- ends and adds the custom attribute definition...
		attributeEnd = ")\n)\ncustAttributes.add $.modifiers[1] cA\nfree ca"

		if posCheck == true or rotCheck == true or scaleCheck == true do (
			params = ""
			spinnersUi = ""

			if posCheck == true do (
				params = params + paramsPos
				spinnersUi = spinnersUi + posGrp
				)
			if rotCheck == true do (
				params = params + paramsRot
				spinnersUi = spinnersUi + rotGrp
				)
			if scaleCheck == true do (
				params = params + paramsScale
				spinnersUi = spinnersUi + scaleGrp
				)

			-- concatenates all the strings...
			uiElements = attributeStart + params + rollStart + spinnersUi + attributeEnd
			execute uiElements
			)
		)
	)

transformSpinnersAttributes_source = transformSpinnersAttributes_source()