struct caSpinner_source (

	-- contains the item label for the main ui...
	attributeLabel = "spinner",

	-- contains the strings to setup the custom attributes...
	fn setUpUiPrp iS tagcolorS = (

		setPropGrp = \
			"group \" spinner: \" (\n"+\
			"checkBox chk_" + iS + " \"integer\" align:#left\n"+\
			"colorpicker tag_color" + iS + " \"\" color:" + tagcolorS + " width:65 height:18 align:#left offset:[-7,0]\n"+\
			"editText sld_name" + iS + " \"\" text:\"edit the name here...\" width:124 height:16 align:#right offset:[0,-43]\n"+\
			"spinner ui_spn_min" + iS + " \"\" width:60 range:[-9999999, 9999999, -100] type:#float align:#center offset:[0,0]\n"+\
			"spinner ui_spn_max" + iS + " \"\" width:60 range:[-9999999, 9999999, 100] type:#float align:#right offset:[0,-21])\n"

		return setPropGrp
		),

	-- contains the strings for the custom attributes rollout...
	fn caParamUi uiIndex rollName colorVal spnName minRange maxRange intChk = (	

		iS = uiIndex as string
		valType = "type:#float"

		if intChk == true do valType = "type:#integer"

		-- sets the parameter block (links the spinner and slider parameters)...
		caParam = "'spn_" + iS + "_" + spnName + "' " + valType + " ui:(spn_spn" + iS + ")\n"

		-- creates the ui (spinner, slider and color tag)...
		rangeVal = "[" + minRange as string + "," + maxRange as string + "," + minRange as string + "]"

		caUi = \
			"group \" " + spnName + ": \" (\n"+\
			"imgTag spn_img" + iS + " bitmap:(bitmap 2 16 color:" + colorVal as string + ") align:#left\n"+\
			"spinner spn_spn" + iS + " \"\" width:148 range:" + rangeVal + " " + valType + " align:#center offset:[0,-21])\n"

		return #(caParam,caUi)
		)
	)

caSpinner_source = caSpinner_source()