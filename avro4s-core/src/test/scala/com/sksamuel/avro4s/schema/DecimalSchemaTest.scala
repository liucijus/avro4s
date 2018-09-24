package com.sksamuel.avro4s.schema

import com.sksamuel.avro4s.internal.{AvroSchema, DataType, DataTypeFor, FixedType}
import org.scalatest.{Matchers, WordSpec}

case class BigDecimalSeqOption(biggies: Seq[Option[BigDecimal]])
case class BigDecimalSeq(biggies: Seq[BigDecimal])
case class BigDecimalDefault(decimal: BigDecimal = 964.55)

class DecimalSchemaTest extends WordSpec with Matchers {

  "SchemaEncoder" should {
    "accept big decimal as logical type on bytes" in {
      case class Test(decimal: BigDecimal)
      val schema = AvroSchema[Test]
      val expected = new org.apache.avro.Schema.Parser().parse(getClass.getResourceAsStream("/bigdecimal.json"))
      schema shouldBe expected
    }
    "support big decimal with default" in {
      val schema = AvroSchema[BigDecimalDefault]
      val expected = new org.apache.avro.Schema.Parser().parse(getClass.getResourceAsStream("/bigdecimal_default.json"))
      schema shouldBe expected
    }
    "suport Option[BigDecimal] as a union" in {
      case class BigDecimalOption(decimal: Option[BigDecimal])
      val schema = AvroSchema[BigDecimalOption]
      val expected = new org.apache.avro.Schema.Parser().parse(getClass.getResourceAsStream("/bigdecimal_option.json"))
      schema shouldBe expected
    }
    "Seq[BigDecimal] be represented as an array of logical types" in {
      val schema = AvroSchema[BigDecimalSeq]
      val expected = new org.apache.avro.Schema.Parser().parse(getClass.getResourceAsStream("/bigdecimal_seq.json"))
      schema shouldBe expected
    }
    "Seq[Option[BigDecimal]] be represented as an array of unions of nulls/bigdecimals" in {
      val schema = AvroSchema[BigDecimalSeqOption]
      val expected = new org.apache.avro.Schema.Parser().parse(getClass.getResourceAsStream("/bigdecimal_seq_option.json"))
      schema shouldBe expected
    }
    "allow big decimals to be encoded as strings when custom typeclasses are provided" in {
      import com.sksamuel.avro4s.BigDecimalAsString._
      case class BigDecimalAsStringTest(decimal: BigDecimal)

      val schema = AvroSchema[BigDecimalAsStringTest]
      val expected = new org.apache.avro.Schema.Parser().parse(this.getClass.getResourceAsStream("/bigdecimal_as_string.json"))
      schema shouldBe expected
    }
    "allow big decimals to be encoded as FIXED when custom typeclasses are provided" in {

      case class BigDecimalAsFixedTest(decimal: BigDecimal)

      implicit object BigDecimalAsFixedCodec extends DataTypeFor[BigDecimal] {
        override def dataType: DataType = FixedType("myfixedtype", 12)
      }

      val schema = AvroSchema[BigDecimalAsFixedTest]
      val expected = new org.apache.avro.Schema.Parser().parse(this.getClass.getResourceAsStream("/bigdecimal_as_fixed.json"))
      schema shouldBe expected
    }
  }
}