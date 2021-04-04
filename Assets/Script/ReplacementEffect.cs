using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementEffect : MonoBehaviour
{
    public Shader shader;

    private void OnEnable()
    {
        if (!shader) return;

        GetComponent<Camera>().SetReplacementShader(shader, "RenderType");
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
