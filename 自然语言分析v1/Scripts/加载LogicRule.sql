USE [nldb]
GO
/****** SSMS 的 SelectTopNRows 命令的脚本  ******/
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('因此$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('因为$a，所以$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('由于$a，因此$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既然$a，就$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('为$a，所以$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('为$a，因此$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('为$a，因而$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('由于$a，所以$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('由于$a，因此$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('由于$a，因而$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('之所以$a，是因为$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既然$a，就$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既然$a，便$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既然$a，则$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既然$a，那么$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既$a，就$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既$a，便$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既$a，则$b', '因果');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既$a，那么$b', '因果');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('如果$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('要是$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('要是$a，那么$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('倘若$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('假使$a，那么$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('假如$a，那么$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('要是$a，那么$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('倘若$a，那么$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('假使$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('假如$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('要是$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('倘若$a，就$b', '假设');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('假使$a，便$b', '假设');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只要$a，就$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只需$a，就$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('一旦$a，就$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只要$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只需$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('一旦$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只要$a，便$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只需$a，便$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('一旦$a，便$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只要$a，总$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只需$a，总$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('一旦$a，总$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('无论$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('凡是$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不管$a，总$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不管$a，也$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('无论$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不论$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不管$a，都$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('任凭$a，都$b', '充分');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('无论$a，也$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不论$a，也$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不管$a，也$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('任凭$a，也$b', '充分');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('无论$a，还$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不论$a，还$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不管$a，还$b', '充分');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('任凭$a，还$b', '充分');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只有$a，才$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('唯有$a，才$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('除非$a，才$b', '必要');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只有$a，否则$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('唯有$a，否则$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('除非$a，否则$b', '必要');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只有$a，不$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('唯有$a，不$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('除非$a，不$b', '必要');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('正是$a，才$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a，要不然$b', '必要');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('除非$a，才$b', '必要');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('以便$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('以$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('用以$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('好$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('为的是$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('以免$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('免得$a', '目的');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('省得$a', '目的');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('可是$a', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('但是$a', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，可是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，但是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，还$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，还$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，但是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽是$a，但是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽说$a，但是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，但是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('固然$a，但是$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，但$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽是$a，但$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽说$a，但$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，但$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('固然$a，但$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，可是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽是$a，可是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽说$a，可是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，可是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('固然$a，可是$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，然而$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽是$a，然而$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽说$a，然而$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，然而$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('固然$a，然而$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽然$a，却$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽是$a，却$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('虽说$a，却$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，却$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('固然$a，却$b', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尽管$a，可是$b', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('却$a', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不过$a', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('然而$a', '转折');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('只是$a', '转折');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('即使$a，也$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就算$a，也$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就是$a，也$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('纵使$a，也$b', '让步');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('即使$a，仍然$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就算$a，仍然$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就是$a，仍然$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('纵使$a，仍然$b', '让步');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('即使$a，还是$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就算$a，还是$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就是$a，还是$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('纵使$a，还是$b', '让步');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('即使$a，还$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就算$a，还$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('就是$a，还$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('纵使$a，还$b', '让步');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('哪怕$a，也$b', '让步');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('再$a，也$b', '让步');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('有的$a，有的$b', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('一方面$a，一方面$b', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('有时$a，有时$b', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('有时候$a，有时候$b', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a一会儿$b，一会儿$c', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('那么$a，那么$b', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('既$a，又$b', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a既$b，又$c', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('也$a', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a也$b，也$c', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('又$a', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('还$a', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('同时$a', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a又$b，又$c', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a不是$b，不是$c', '并列');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a不是$b，而是$c', '并列');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a一$b，就$c', '承接');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a首先$b，然后$c', '承接');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a便$b', '承接');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a于是$b', '承接');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a才$b', '承接');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a接着$b', '承接');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不仅$a，还$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a不但不$b，反而$c', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('除了$a，还有$b', '递进');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不但$a，而且$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不仅$a，而且$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不光$a，而且$b', '递进');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不但$a，并且$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不仅$a，并且$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不光$a，并且$b', '递进');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不但$a，还$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不但$a，也$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不但$a，又$b', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不但$a，更$b', '递进');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a不仅$b，还$c', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a连$b，也$c', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('何况$a', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('而且$a', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('况且$a', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('尤其$a', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('甚至$a', '递进');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a，更不要说$b', '递进');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('是$a，还是$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('或者$a，或者$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a或是$b，或是$c', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('不是$a，就是$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('要么$a，要么$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('与其$a，不如$b', '选择');

INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('宁可$a，也不$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('宁可$a，也决不$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('宁可$a，不$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('宁可$a，不愿$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('宁愿$a，不$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('宁愿$a，不愿$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('与其$a，不如$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('与其$a，无宁$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('与其$a，宁可$b', '选择');
INSERT INTO dbo.RulePool (parse_rule, classification) VALUES ('$a还是$b', '选择');