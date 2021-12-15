SET SQL_SAFE_UPDATES = 0;

DROP FUNCTION GetKeyboardPrice;

DELIMITER //
CREATE FUNCTION GetKeyboardPrice(kb_id INT) RETURNS DECIMAL(19,2)
BEGIN
DECLARE total, PCBCost, SwitchCost, KeycapCost, StabilizerCost, CaseCost, CableCost DECIMAL(19,2);
SET PCBCost = (
	SELECT b.PCBCost FROM Keyboard AS a INNER JOIN PCB as b ON a.PCBID = b.PCBID WHERE a.KeyboardID = kb_id);
SET SwitchCost = (
	SELECT b.SwitchCost FROM Keyboard AS a INNER JOIN Switch as b ON a.SwitchID = b.SwitchID WHERE a.KeyboardID = kb_id);
SET KeycapCost = (
	SELECT b.KeycapCost FROM Keyboard AS a INNER JOIN Keycaps as b ON a.KeycapID = b.KeycapID WHERE a.KeyboardID = kb_id);
SET StabilizerCost = (
	SELECT b.StabilizerCost FROM Keyboard AS a INNER JOIN Stabilizers as b ON a.StabilizerID = b.StabilizerID WHERE a.KeyboardID = kb_id);
SET CaseCost = (
	SELECT b.CaseCost FROM Keyboard AS a INNER JOIN Case_ as b ON a.CaseID = b.CaseID WHERE a.KeyboardID = kb_id);
SET CableCost = (
	SELECT b.CableCost FROM Keyboard AS a INNER JOIN USBCable as b ON a.CableID = b.CableID WHERE a.KeyboardID = kb_id);

SET total = 1.25*(PCBCost + SwitchCost + KeycapCost + StabilizerCost + CaseCost + CableCost);
RETURN total;
END//
DELIMITER ;

SELECT GetKeyboardPrice(1) as KeyboardPrice;

SELECT
	 b.PCBCost,
	 c.SwitchCost,
	 d.KeycapCost,
	 e.StabilizerCost,
	 f.CaseCost,
	 g.CableCost
	FROM Keyboard AS a
	INNER JOIN PCB AS b ON a.PCBID = b.PCBID
	INNER JOIN Switch AS c ON a.SwitchID = c.SwitchID
	INNER JOIN Keycaps AS d ON a.KeycapID = d.KeycapID
	INNER JOIN Stabilizers AS e ON a.StabilizerID = e.StabilizerID
	INNER JOIN Case_ AS f ON a.CaseID = f.CaseID
	INNER JOIN USBCable AS g ON a.CableID = g.CableID
	WHERE a.KeyboardID = 2;