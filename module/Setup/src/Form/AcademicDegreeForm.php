<?php
namespace Setup\Form;
/**
 * Created by PhpStorm.
 * User: root
 * Date: 11/10/16
 * Time: 5:31 PM
 */

use Zend\Form\Annotation;

/**
 * @Annotation\Hydrator("Zend\Hydrator\ObjectProperty")
 * @Annotation\Name("AcademicDegree")
 */

class AcademicDegreeForm{

    /**
     * @Annotion\Type("Zend\Form\Element\Text")
     * @Annotation\Required({"required":"true"})
     * @Annotation\Filter({"name":"StringTrim","name":"StripTags"})
     * @Annotation\Options({"label":"Academic Degree Code"})
     * @Annotation\Attributes({ "id":"form-academicDegreeCode", "class":"form-academicDegreeCode form-control" })
     */
    public $academicDegreeCode;

    /**
     * @Annotion\Type("Zend\Form\Element\Text")
     * @Annotation\Required({"required":"true"})
     * @Annotation\Filter({"name":"StringTrim","name":"StripTags"})
     * @Annotation\Options({"label":"Academic Degree Name"})
     * @Annotation\Validator({"name":"StringLength", "options":{"min":"5"}})
     * @Annotation\Attributes({ "id":"form-academicDegreeName", "class":"form-academicDegreeName form-control" })
     */
    public $academicDegreeName;

    /**
     * @Annotion\Type("Zend\Form\Element\Number")
     * @Annotation\Required({"required":"true"})
     * @Annotation\Filter({"name":"StringTrim","name":"StripTags"})
     * @Annotation\Options({"label":"Weight"})
     * @Annotation\Attributes({ "id":"form-weight", "class":"form-weight form-control" })
     */
    public $weight;

    /**
     * @Annotation\Type("Zend\Form\Element\Textarea")
     * @Annotation\Required(false)
     * @Annotation\Filter({"name":"StripTags","name":"StringTrim"})
     * @Annotation\Options({"label":"Remarks"})
     * @Annotation\Attributes({"id":"form-remarks","class":"form-remarks form-control","style":"height: 50px"})
     */
    public $remarks;

    /**
     * @Annotation\Type("Zend\Form\Element\Submit")
     * @Annotation\Attributes({"value":"Submit","class":"btn btn-success"})
     */
    public $submit;
}