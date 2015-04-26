using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Workouts_VS
{

    enum Color
    {
        RED = 0,
        BLACK = 1
    }
    /// <summary>
    /// left leaning red black tree
    /// </summary>
    /// 
    class Node : IComparable<Node>, IComparer<Node>, IComparable<int>
    {
        public int data;
        public Color color;
        public Node left, right, parent;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        /// <param name="parent"></param>
        public Node(int data, Node parent)
        {
            this.data = data;
            this.parent = parent;
            color = Color.RED;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public int CompareTo(Node other)
        {
            if (other.data == data)
            {
                return 0;
            }
            else if (data < other.data)
            {
                return -1;
            }
            else
            {
                return 1;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        public int Compare(Node x, Node y)
        {
            return x.CompareTo(y);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="other"></param>
        /// <returns></returns>
        public int CompareTo(int other)
        {
            if (other == data)
            {
                return 0;
            }
            else if (data < other)
            {
                return -1;
            }
            else
            {
                return 1;
            }
        }
    }

    class RedBlackTree
    {
        static Node root = null;

        // 1, the number of black nodes on any path to leaves are same
        // 2, there cannot be two adjacent red nodes
        // 3, root should be a black node
        public static void Main(String[] args)
        {
            int option = 0;
            do
            {
                Console.WriteLine("Enter the option: 1. Insert, 2: Delete, 3: Display, 4:Exit");
                Console.Write("option: ");
                option = Int32.Parse(Console.ReadLine());

                switch (option)
                {
                    case 1:
                        {
                            int data = Int32.Parse(Console.ReadLine());
                            root = insertIntoRBTree(root, data);
                            root.color = Color.BLACK;
                        }
                        break;
                    case 2:
                        {
                            int data = Int32.Parse(Console.ReadLine());
                            root = deleteFromRBTree(root, data);
                        }
                        break;
                    case 3:
                        Console.WriteLine();

                        display(root, 0);
                        break;
                    default:
                        break;
                }

            } while (option != 4);
        }

        private static void display(Node node, int level)
        {
            if (node == null) return;

            display(node.left, level + 1);
            Console.WriteLine("level=" + level + " : " + node.data + " : " + node.color);
            display(node.right, level + 1);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        private static Node deleteFromRBTree(Node node, int data)
        {
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        private static Node insertIntoRBTree(Node node, int data)
        {
            if (node == null)
            {
                return new Node(data, null);
            }

            int compare = node.CompareTo(data);
            if (compare == 0)
            {
                return node;
            }
            else if (compare < 0)
            {
                node.right = insertIntoRBTree(node.right, data);
            }
            else
            {
                node.left = insertIntoRBTree(node.left, data);
            }

            //if the right child of node is red, the rotate left
            if (!isRed(node.left) && isRed(node.right)) node = rotateLeft(node);

            //if the left child, and left left child are RED, rotate right
            if (isRed(node.left) && isRed(node.left.left)) node = rotateRight(node);

            // flip color if needed
            if (isRed(node.left) && isRed(node.right)) flipColor(node);

            return node;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        private static Node rotateRight(Node node)
        {
            Console.WriteLine("rotate right");
            Node X = node.left.right;
            Node neededNode = node.left;

            node.left = X;
            neededNode.right = node;
            neededNode.color = node.color;
            node.color = Color.RED;

            return neededNode;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        private static Node rotateLeft(Node node)
        {
            Console.WriteLine("rotate left");
            Node neededNode = node.right;
            Node X = node.right.left;

            node.right = X;
            neededNode.left = node;

            neededNode.color = node.color;
            node.color = Color.RED;

            return neededNode;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        private static void flipColor(Node node)
        {
            Console.WriteLine("flip color");
            node.color = (Color)(1 - (int)node.color);
            node.left.color = (Color)(1 - (int)node.color);
            node.right.color = (Color)(1 - (int)node.color);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        private static bool isRed(Node node)
        {
            return (node != null && node.color == Color.RED);
        }

    }
}
