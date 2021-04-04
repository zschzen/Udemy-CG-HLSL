using System;
using UnityEngine;

[ExecuteInEditMode]
public class RotateItem : MonoBehaviour
{
    public bool isRotate;
    public float speed = 100;
    private float t;

    private void OnDrawGizmos()
    {
        if (Input.GetKeyDown(KeyCode.Space)) isRotate = !isRotate;
        if (!isRotate) return;
        
        t = Time.deltaTime;
        transform.Rotate(new Vector3(0, speed * t, 0)); // X; Y; Z
    }
}
