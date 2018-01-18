using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    public class GraphData
    {
        public float[,] pData;
        public List<string> pYName = new List<string>();
        public List<string> pXName = new List<string>();
        public string GraphName;
        public string Xalname;
        public string Yalname;
        public int YShow = -1;
    }
}
