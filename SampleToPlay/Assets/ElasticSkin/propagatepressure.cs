///<summary>
/// 概要：このクラスはInputクラスから受けた圧力をShaderに対して受け渡すためのクラスです。
///
/// <filename>
/// propagatepressure.cs
/// </filename>
///
/// <creatername>
/// 作成者：堀　明博
/// </creatername>
/// 
/// <address>
/// mailladdress:herie270714@gmail.com
/// </address>
///</summary>


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class propagatepressure : MonoBehaviour 
{

    [SerializeField]
    private Material skin_material;

    [SerializeField]
    private Light light;

    Vector3 light_dir;

	// Use this for initialization
	void Start () 
	{
        Vector3 _front = Vector3.forward;

        light_dir = light.transform.rotation * _front;
	}
	
	// Update is called once per frame
	void Update () 
	{
        Vector3 _front = Vector3.forward;

        light_dir = light.transform.rotation * _front;
        //Debug.DrawRay(light.transform.position, light_dir);
        skin_material.SetVector("_LightDir", light_dir);
        Debug.DrawLine(transform.position, light_dir * 3,Color.magenta);

	}

}
