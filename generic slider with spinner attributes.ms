struct gernericSliderWithSpinnerAttributes_source (

	-- contains the item label for the main ui...
	attributeLabel = "slider with spinner",

	-- contains the strings to setup the custom attributes...
	fn setPropUi iS tagcolorS = (

		setPropGrp = (\
			"group \" slider with spinner: \" (\n"+\
			"colorpicker tag_color" + iS + " \"\" color:" + tagcolorS + " width:65 height:40 align:#left offset:[-7,0]\n"+\
			"editText sld_name" + iS + " \"\" text:\"edit the name here...\" width:124 height:16 align:#right offset:[0,-44]\n"+\
			"spinner ui_spn_min" + iS + " \"\" width:60 range:[-9999999,9999999,-100] type:#float align:#center offset:[0,0]\n"+\
			"spinner ui_spn_max" + iS + " \"\" width:60 range:[-9999999,9999999,100] type:#float align:#right offset:[0,-21])\n"
			)

		caParams = "(gernericSliderWithSpinnerAttributes_source.buildUi " + iS + " \"rollName\" " + tagcolorS + " \"sldName\" -10 10)[1]\n"

		caUi = "(gernericSliderWithSpinnerAttributes_source.buildUi " + iS + " \"rollName\" " + tagcolorS + " \"sldName\" -10 10)[2]\n"

		return #(setPropGrp,caParams,caUi)
		),

	-- contains the strings for the custom attributes rollout...
	fn buildUi uiIndex rollName colorVal sldName minRange maxRange = (	

		iS = uiIndex as string

		-- sets the parameter block (links the spinner and slider parameters)...
		params = ("'" + iS + "_" + sldName + "' type:#float ui:(spn" + iS + ",sld" + iS + ")\n")

		-- creates the ui (spinner, slider and color tag)...
		rangeVal = "[" + minRange as string + "," + maxRange as string + "," + minRange as string + "]"
		colorui = (\
			"group \" " + sldName + ": \" (\n"+\
			"imgTag img" + iS + " bitmap:(bitmap 2 48 color:" + colorVal as string + ") align:#left\n"+\
			"spinner spn" + iS + " \"\" width:136 range:" + rangeVal + " type:#float scale:0.01 align:#center offset:[2,-50]\n"+\
			"slider sld" + iS + " \"\" width:149 range:" + rangeVal + " ticks:6 align:#center offset:[8,-2]\n)\n"\
			)

		--execute uiElements
		return #(params,colorui)
		)
	)

gernericSliderWithSpinnerAttributes_source = gernericSliderWithSpinnerAttributes_source()

(gernericSliderWithSpinnerAttributes_source.buildUi 1 "rollName" (color 177 28 226) "sldName" -10 10)[2]