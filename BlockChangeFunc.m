function NextBlock = BlockChangeFunc(TrialRecord)
	if TrialRecord.CurrentTrialWithinBlock == 20
		NextBlock = 1;
	else
		NextBlock = 0;
	end
end